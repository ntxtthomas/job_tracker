require "digest"
require "securerandom"

class CommunityPulseVotesController < ApplicationController
  skip_before_action :require_authentication_for_writes, only: :create

  DAILY_LIMIT_MAX = 5
  RATE_LIMIT_WINDOW = 10.minutes
  RATE_LIMIT_MAX = 5
  RATE_LIMIT_ERROR = "Too many votes from this connection. Please try again in a few minutes.".freeze
  DAILY_LIMIT_ERROR = "You have reached today's vote limit. Please come back tomorrow.".freeze

  def create
    daily_count = daily_votes_count
    votes_remaining = [ DAILY_LIMIT_MAX - daily_count, 0 ].max
    daily_limit_reached = votes_remaining.zero?
    error_message = nil
    status = :ok

    if rate_limited?
      error_message = RATE_LIMIT_ERROR
      status = :too_many_requests
    elsif daily_limit_reached
      error_message = DAILY_LIMIT_ERROR
    else
      vote = CommunityPulseVote.new(
        topic: vote_params[:topic],
        fingerprint: vote_fingerprint
      )

      if vote.save
        increment_daily_votes!
        daily_count = daily_votes_count
        votes_remaining = [ DAILY_LIMIT_MAX - daily_count, 0 ].max
        daily_limit_reached = votes_remaining.zero?
      else
        error_message = "Vote was not recorded. Please try again."
      end
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "community_pulse_panel",
          partial: "community_pulse_votes/panel",
          locals: {
            votes_remaining: votes_remaining,
            daily_limit_reached: daily_limit_reached,
            error_message: error_message
          }
        ), status: status
      end

      format.html do
        flash[:alert] = error_message if error_message.present?
        redirect_to new_user_session_path(anchor: "community-pulse")
      end
    end
  end

  private

  def vote_params
    params.require(:community_pulse_vote).permit(:topic)
  end

  def daily_votes_count
    payload = cookies.encrypted[:community_pulse_daily_votes]
    return 0 unless payload.is_a?(Hash)

    stored_date = payload["date"] || payload[:date]
    return 0 unless stored_date == Date.current.iso8601

    (payload["count"] || payload[:count]).to_i
  end

  def increment_daily_votes!
    cookies.encrypted[:community_pulse_daily_votes] = {
      value: {
        date: Date.current.iso8601,
        count: daily_votes_count + 1
      },
      expires: 2.days.from_now,
      httponly: true
    }
  end

  def rate_limited?
    key = rate_limit_cache_key
    current_count = Rails.cache.read(key).to_i

    if current_count >= RATE_LIMIT_MAX
      true
    else
      Rails.cache.write(key, current_count + 1, expires_in: RATE_LIMIT_WINDOW)
      false
    end
  end

  def rate_limit_cache_key
    "community_pulse_votes:rate_limit:#{Digest::SHA256.hexdigest(request.remote_ip.to_s)}"
  end

  def vote_fingerprint
    raw = [
      request.remote_ip,
      request.user_agent.to_s.first(140),
      Time.current.to_f,
      SecureRandom.hex(8)
    ].join("|")
    Digest::SHA256.hexdigest(raw)
  end
end
