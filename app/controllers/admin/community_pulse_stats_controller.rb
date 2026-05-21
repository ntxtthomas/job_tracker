module Admin
  class CommunityPulseStatsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin_user

    def index
      @today_counts = counts_for_range(Date.current.beginning_of_day..Time.current)
      @today_total = @today_counts.values.sum

      @daily_rows = (0..6).map do |days_ago|
        day = Date.current - days_ago.days
        range = day.beginning_of_day..day.end_of_day
        counts = counts_for_range(range)

        {
          date: day,
          counts: counts,
          total: counts.values.sum
        }
      end
    end

    private

    def require_admin_user
      return if admin_user?

      redirect_to dashboard_path, alert: "Admin access only."
    end

    def counts_for_range(range)
      grouped_counts = CommunityPulseVote.where(created_at: range).group(:topic).count

      CommunityPulseVote::TOPIC_LABELS.keys.index_with { |topic_key| grouped_counts[topic_key].to_i }
    end
  end
end
