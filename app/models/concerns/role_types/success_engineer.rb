module RoleTypes
  module SuccessEngineer
    extend ActiveSupport::Concern

    # Success Engineer specific metadata structure:
    # {
    #   customer_segment: "enterprise", # smb, mid_market, enterprise
    #   csm_model: "strategic", # transactional, strategic, pooled
    #   account_load: "15-20", # number of accounts
    #   renewal_responsibility: true,
    #   expansion_quota: true,
    #   onboarding_intensity: "high", # low, medium, high
    #   customer_health_metrics: ["nps", "product_usage"], # nps, product_usage, support_tickets, engagement_score
    #   escalation_frequency: "weekly", # daily, weekly, monthly, rare
    #   technical_depth: ["integrations", "troubleshooting"], # integrations, troubleshooting, configuration, apis
    #   pressure_sources: {
    #     churn_risk: true,
    #     renewal_pressure: true,
    #     travel_percent: 10,
    #     on_call_support: false,
    #     exec_engagement: "medium"
    #   },
    #   success_signals: ["retention_rate", "expansion_revenue"], # retention_rate, expansion_revenue, nps, adoption_rate, customer_satisfaction
    #   fit_reasons: ["relationship_builder", "problem_solver"], # relationship_builder, problem_solver, product_expert, strategic_advisor, empathy_driven
    #   nervous_system_cost: "medium", # low, medium, high
    #   energy_type: "supporting", # supporting, collaborating, advising
    #   identity_alignment: "advocate", # advocate, consultant, partner
    #   remote_tolerance: "flexible" # strict, flexible, hybrid
    # }

    included do
      validate :validate_success_engineer_metadata, if: -> { role_type == "success_engineer" }
    end

    def validate_success_engineer_metadata
      nil if role_metadata.blank?

      # Optional: Add validations for required fields
      # errors.add(:role_metadata, "must include customer_segment") unless role_metadata["customer_segment"].present?
    end

    def customer_segment_summary
      return "Not specified" unless role_metadata["customer_segment"].present?

      parts = []
      parts << role_metadata["customer_segment"]&.titleize
      parts << role_metadata["csm_model"]&.titleize if role_metadata["csm_model"].present?
      parts << "#{role_metadata['account_load']} accounts" if role_metadata["account_load"].present?

      parts.join(" • ")
    end

    def success_metrics_summary
      metrics = role_metadata["customer_health_metrics"]
      return "Not specified" unless metrics.is_a?(Array) && metrics.any?

      metrics.map { |m| m.gsub("_", " ").titleize }.join(", ")
    end

    def success_pressure_summary
      pressure = role_metadata["pressure_sources"]
      return "Not specified" unless pressure.is_a?(Hash)

      parts = []
      parts << "Churn risk" if pressure["churn_risk"]
      parts << "Renewal pressure" if pressure["renewal_pressure"]
      parts << "#{pressure['travel_percent']}% travel" if pressure["travel_percent"]

      parts.any? ? parts.join(" • ") : "Low pressure"
    end
  end
end
