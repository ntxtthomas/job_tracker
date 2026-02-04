module RoleTypes
  module Other
    extend ActiveSupport::Concern

    # Other role metadata structure can be anything that doesn't fit the defined roles.

    included do
      validate :validate_other_role_metadata, if: -> { role_type == "other" }
    end

    def validate_other_role_metadata
      # No required metadata for "other"
    end
  end
end
