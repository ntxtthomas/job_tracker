class Technology < ApplicationRecord
  has_many :opportunity_technologies, dependent: :destroy
  has_many :opportunities, through: :opportunity_technologies

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  # Category constants for easier reference
  CATEGORIES = [
    "Backend",
    "Frontend",
    "Database",
    "Testing",
    "DevOps/Infrastructure",
    "API/Integration",
    "Other"
  ].freeze
end
