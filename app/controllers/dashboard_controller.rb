class DashboardController < ApplicationController
  def index
    @total_resumes = Opportunity.where(status: "submitted").count
    @total_responses = Opportunity.where(status: "responded").count
    @total_interviews = Opportunity.where(status: "interview").count
    @total_offers = Opportunity.where(status: "offer").count
  end
end
