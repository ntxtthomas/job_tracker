module RoleTypes
  module SupportEngineer
    extend ActiveSupport::Concern

    # Support Engineer specific metadata structure:
    # {
    #   support_tier: "l2", # l1, l2, l3
    #   on_call: true,
    #   ticket_volume: "high", # low, medium, high
    #   escalation_path: "engineering", # engineering, product, customer_success
    #   support_tools: ["zendesk", "jira"],
    #   shift_type: "rotating" # fixed, rotating, follow_the_sun
    # }

    included do
      validate :validate_support_engineer_metadata, if: -> { role_type == "support_engineer" }
    end

    def validate_support_engineer_metadata
      # Add any specific validations for support engineer roles
    end

    def support_summary
      return "Not specified" unless role_metadata["support_tier"].present?

      tier = role_metadata["support_tier"].upcase
      on_call = role_metadata["on_call"] ? "On-call" : nil

      ["Tier #{tier}", on_call].compact.join(" • ")
    end
  end
end
