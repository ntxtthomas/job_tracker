class OpportunityTechnology < ApplicationRecord
  belongs_to :opportunity
  belongs_to :technology

  validates :opportunity_id, uniqueness: { scope: :technology_id }
end
