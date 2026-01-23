module RoleTypes
  module SalesEngineer
    extend ActiveSupport::Concern

    # Sales Engineer specific metadata structure:
    # {
    #   sales_motion: "enterprise", # smb, mid_market, enterprise
    #   deal_type: "new_logo", # new_logo, expansion, both
    #   acv_range: "$50k-$500k",
    #   sales_cycle_length: "3-6 months",
    #   quota_type: "influence", # influence, ownership
    #   customer_persona: ["business_users", "operators"], # array
    #   domain_depth: "deep", # shallow, moderate, deep
    #   demo_intensity: "custom", # scripted, custom, sandbox, live_integration, roi_modeling
    #   technical_depth: ["apis", "integrations"], # apis, integrations, data_models, security, config
    #   pressure_sources: {
    #     quota_pressure: true,
    #     travel_percent: 25,
    #     overtime_expected: true,
    #     deal_urgency: "quarterly",
    #     exec_visibility: "high"
    #   },
    #   success_signals: ["revenue_influenced", "win_rate"], # revenue_influenced, win_rate, deal_velocity, demo_to_close, expansion
    #   fit_reasons: ["domain_expert", "former_customer"], # prior_customer, domain_operator, technical_translator, relationship_builder, change_agent
    #   nervous_system_cost: "medium", # low, medium, high
    #   energy_type: "presenting", # presenting, collaborating, building
    #   identity_alignment: "advisor", # builder, advisor, closer
    #   remote_tolerance: "flexible" # strict, flexible, onsite
    # }

    included do
      validate :validate_sales_engineer_metadata, if: -> { role_type == "sales_engineer" }
    end

    def validate_sales_engineer_metadata
      nil if role_metadata.blank?

      # Optional: Add validations for required fields
      # errors.add(:role_metadata, "must include sales_motion") unless role_metadata["sales_motion"].present?
    end

    def sales_motion_summary
      return "Not specified" unless role_metadata["sales_motion"].present?

      parts = []
      parts << role_metadata["sales_motion"]&.titleize
      parts << role_metadata["deal_type"]&.gsub("_", " ")&.titleize if role_metadata["deal_type"].present?
      parts << role_metadata["acv_range"] if role_metadata["acv_range"].present?

      parts.join(" • ")
    end

    def customer_persona_summary
      personas = role_metadata["customer_persona"]
      return "Not specified" unless personas.is_a?(Array) && personas.any?

      personas.map { |p| p.gsub("_", " ").titleize }.join(", ")
    end

    def pressure_summary
      pressure = role_metadata["pressure_sources"]
      return "Not specified" unless pressure.is_a?(Hash)

      parts = []
      parts << "Quota pressure" if pressure["quota_pressure"]
      parts << "#{pressure['travel_percent']}% travel" if pressure["travel_percent"]
      parts << "Overtime expected" if pressure["overtime_expected"]

      parts.any? ? parts.join(" • ") : "Low pressure"
    end
  end
end
