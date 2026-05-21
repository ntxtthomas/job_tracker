require "digest"

class CommunityPulseVotesController < ApplicationController
  skip_before_action :require_authentication_for_writes, only: :create

  RATE_LIMIT_WINDOW = 10.minutes
  RATE_LIMIT_MAX = 5
  RATE_LIMIT_ERROR = "Too many votes from this connection. Please try again in a few minutes.".freeze

  def create
    already_voted = voted_recently?
    error_message = nil
    status = :ok

    if rate_limited?
      error_message = RATE_LIMIT_ERROR
      status = :too_many_requests
    elsif already_voted
      error_message = nil
    else
      vote = CommunityPulseVote.new(
        topic: vote_params[:topic],
        fingerprint: vote_fingerprint
      )

      if vote.save
        mark_voted!
        already_voted = true
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
            already_voted: already_voted,
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

  def voted_recently?
    cookies.encrypted[:community_pulse_voted_at].present?
  end

  def mark_voted!
    cookies.encrypted[:community_pulse_voted_at] = {
      value: Time.current.to_i,
      expires: 24.hours.from_now,
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
    raw = [request.remote_ip, request.user_agent.to_s.first(140), Date.current.to_s].join("|")
    Digest::SHA256.hexdigest(raw)
  end
end
