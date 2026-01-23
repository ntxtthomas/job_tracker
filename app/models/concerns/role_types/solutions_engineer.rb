module RoleTypes
  module SolutionsEngineer
    extend ActiveSupport::Concern

    # Solutions Engineer specific metadata structure:
    # {
    #   solution_scope: "implementation", # pre_sales, implementation, post_sales, hybrid
    #   customer_size: "enterprise", # smb, mid_market, enterprise
    #   technical_complexity: "high", # low, medium, high
    #   customer_facing_percent: 60,
    #   implementation_depth: "deep", # shallow, moderate, deep
    #   integration_heavy: true,
    #   customization_level: "high", # low, medium, high
    #   support_vs_project: "project", # support, balanced, project
    #   success_metrics: ["customer_satisfaction", "implementation_speed"],
    #   required_skills: ["api_integration", "data_migration"], # array of technical skills
    #   domain_knowledge: "moderate", # shallow, moderate, deep
    #   travel_requirement: 20, # percentage
    #   on_call_requirement: false
    # }

    included do
      validate :validate_solutions_engineer_metadata, if: -> { role_type == "solutions_engineer" }
    end

    def validate_solutions_engineer_metadata
      # Add any specific validations for solutions engineer roles
    end

    def solution_scope_summary
      return "Not specified" unless role_metadata["solution_scope"].present?

      scope = role_metadata["solution_scope"].gsub("_", " ").titleize
      complexity = role_metadata["technical_complexity"]&.titleize

      [ scope, complexity ].compact.join(" • ")
    end
  end
end
