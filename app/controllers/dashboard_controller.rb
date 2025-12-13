class DashboardController < ApplicationController
  def index
    @total_potentials = Opportunity.where(application_date: nil).count
    @total_resumes = Opportunity.where.not(application_date: nil).count
    @total_responses = Opportunity.where(status: "responded").count
    @total_interviews = Opportunity.where(status: "interview").count
    @total_offers = Opportunity.where(status: "offer").count

    # Tech stack breakdown
    @tech_stack_data = Opportunity.where.not(tech_stack: [ nil, "" ])
                                  .group(:tech_stack)
                                  .count
                                  .sort_by { |_, count| -count }
                                  .to_h

    # Source breakdown
    @source_data = Opportunity.where.not(source: [ nil, "" ])
                              .group(:source)
                              .count
                              .sort_by { |_, count| -count }
                              .to_h

    # Applications by week (last 4 weeks)
    @weekly_data = calculate_weekly_applications
  end

  private

  def calculate_weekly_applications
    today = Date.today
    weeks = []

    4.downto(1) do |i|
      week_start = today - (i * 7).days
      week_end = week_start + 6.days

      count = Opportunity.where(application_date: week_start..week_end).count

      weeks << {
        label: "#{week_start.strftime('%b %d')} - #{week_end.strftime('%b %d')}",
        count: count,
        start_date: week_start,
        end_date: week_end,
        week_number: i
      }
    end

    weeks
  end
end
