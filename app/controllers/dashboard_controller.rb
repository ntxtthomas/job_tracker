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
  end
end
