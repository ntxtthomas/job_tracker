class DashboardController < ApplicationController
  def index
    @total_potentials = Opportunity.where(application_date: nil).count
    @total_resumes = Opportunity.where.not(application_date: nil).count
    @total_responses = Opportunity.where(status: "responded").count
    @total_interviews = Opportunity.where(status: "interview").count
    @total_offers = Opportunity.where(status: "offer").count
    @total_assessed = Opportunity.count

    # Tech stack analytics
    opportunities_with_tech = Opportunity.joins(:technologies).distinct
    analyzer = TechStackAnalyzer.new(opportunities_with_tech)

    @tech_combinations = analyzer.analyze_main_stack_combinations.first(10).to_h # Top 10 simplified combinations
    @learning_insights = analyzer.learning_insights(limit: 5)
    @top_technologies = analyzer.top_technologies(limit: 15)

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

    # TWC (Texas Workforce Commission) weeks: Friday through Thursday
    # Calculate days back to find the most recent Friday
    days_back_to_friday = (today.wday - 5) % 7
    current_week_start = today - days_back_to_friday.days
    current_week_end = current_week_start + 6.days

    # Show current week + 3 previous weeks
    4.times do |i|
      if i == 0
        week_start = current_week_start
        week_end = current_week_end
      else
        week_end = current_week_start - 1.day
        week_start = week_end - 6.days
        current_week_start = week_start
      end

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
