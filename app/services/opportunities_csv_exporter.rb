require "csv"

class OpportunitiesCsvExporter
  def initialize(opportunities, title: nil)
    @opportunities = opportunities
    @title = title
  end

  def generate
    CSV.generate(headers: true) do |csv|
      # Add title row if provided
      if @title.present?
        csv << [ @title ]
        csv << [] # Empty row for spacing
      end

      csv << headers

      @opportunities.each do |opportunity|
        # Combine structured technologies with other_tech_stack
        tech_list = opportunity.technologies.order(:category, :name).pluck(:name).join(", ")
        tech_list += ", #{opportunity.other_tech_stack}" if opportunity.other_tech_stack.present?
        tech_list = tech_list.presence || opportunity.tech_stack # Fallback to old field if no structured data
        
        csv << [
          opportunity.company.name,
          opportunity.position_title,
          opportunity.application_date,
          opportunity.status,
          tech_list,
          opportunity.salary_range,
          opportunity.chatgpt_match,
          opportunity.jobright_match,
          opportunity.linkedin_match
        ]
      end
    end
  end

  private

  def headers
    [
      "Company",
      "Position Title",
      "Application Date",
      "Status",
      "Tech Stack",
      "Salary Range",
      "ChatGPT Match",
      "Jobright Match",
      "LinkedIn Match"
    ]
  end
end
