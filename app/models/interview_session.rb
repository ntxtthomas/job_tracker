class InterviewSession < ApplicationRecord
  belongs_to :opportunity

  # Enums
  enum :stage, {
    recruiter: "recruiter",
    tech_screen: "tech_screen",
    panel: "panel",
    final: "final",
    hiring_manager: "hiring_manager",
    peer: "peer",
    behavioral: "behavioral"
  }, prefix: true

  enum :overall_signal, {
    strong: "strong",
    neutral: "neutral",
    weak: "weak"
  }, prefix: true

  # Validations
  validates :stage, presence: true
  validates :date, presence: true
  validates :confidence_score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
  validates :clarity_score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true

  # Scopes
  scope :recent, -> { order(date: :desc) }
  scope :by_stage, ->(stage) { where(stage: stage) }
  scope :strong_signals, -> { where(overall_signal: :strong) }
  scope :this_month, -> { where(date: Date.today.beginning_of_month..Date.today.end_of_month) }

  # Methods
  def performance_score
    return nil unless confidence_score.present? && clarity_score.present?

    (confidence_score + clarity_score) / 2.0
  end

  def needs_follow_up?
    follow_up.present? && follow_up.strip.length > 0
  end

  def has_preparation_gaps?
    weak_areas.present? && weak_areas.strip.length > 0
  end
end
