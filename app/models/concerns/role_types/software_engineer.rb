module RoleTypes
  module SoftwareEngineer
    extend ActiveSupport::Concern

    # Software Engineer specific metadata structure:
    # {
    #   tech_stack_importance: "high", # low, medium, high
    #   required_technologies: [...], # specific must-haves
    #   nice_to_have_technologies: [...],
    #   architecture_type: "microservices", # monolith, microservices, etc
    #   team_size: "small", # small, medium, large
    #   greenfield_vs_legacy: "legacy" # greenfield, legacy, mixed
    # }

    included do
      # Validation: Software engineers should have tech stack information
      validate :validate_software_engineer_metadata, if: -> { role_type == "software_engineer" }
    end

    def validate_software_engineer_metadata
      # Tech stack still relevant for software engineers
      # but now optional since it's in the metadata
    end

    def tech_stack_summary
      return tech_stack if tech_stack.present?

      techs = technologies.pluck(:name).join(", ")
      techs.present? ? techs : "Not specified"
    end
  end
end
