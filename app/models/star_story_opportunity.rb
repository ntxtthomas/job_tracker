class StarStoryOpportunity < ApplicationRecord
  belongs_to :star_story
  belongs_to :opportunity

  validates :star_story_id, uniqueness: { scope: :opportunity_id }
end
