module RoleTypes
  module ProductManager
    extend ActiveSupport::Concern

    # Product Manager specific metadata structure:
    # {
    #   product_stage: "growth", # early_stage, growth, mature
    #   product_type: "b2b_saas", # b2b_saas, b2c, platform, infrastructure
    #   pm_type: "technical", # technical, growth, platform, core
    #   team_size: 5,
    #   engineering_ratio: "1:5", # PM to engineer ratio
    #   stakeholder_complexity: "high", # low, medium, high
    #   data_driven_level: "high", # low, medium, high
    #   technical_depth_required: "moderate", # low, moderate, high
    #   strategy_vs_execution: "balanced", # strategy, balanced, execution
    #   customer_interaction: "frequent", # rare, occasional, frequent
    #   domain_expertise_required: "moderate", # shallow, moderate, deep
    #   roadmap_horizon: "6_months", # quarterly, 6_months, annual
    #   success_metrics: ["user_adoption", "revenue_impact"]
    # }

    included do
      validate :validate_product_manager_metadata, if: -> { role_type == "product_manager" }
    end

    def validate_product_manager_metadata
      # Add any specific validations for product manager roles
    end

    def product_summary
      return "Not specified" unless role_metadata["product_stage"].present?
      
      parts = []
      parts << role_metadata["product_stage"]&.gsub("_", " ")&.titleize
      parts << role_metadata["pm_type"]&.gsub("_", " ")&.titleize + " PM" if role_metadata["pm_type"].present?
      
      parts.join(" • ")
    end
  end
end
