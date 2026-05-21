class CommunityPulseVote < ApplicationRecord
  STREAM_KEY = "community_pulse".freeze

  TOPIC_LABELS = {
    "getting_interviews" => "Getting interviews",
    "passing_screens" => "Passing screens",
    "salary_negotiation" => "Salary negotiation",
    "storytelling" => "Storytelling"
  }.freeze

  enum :topic, TOPIC_LABELS.keys.index_with { |value| value }, prefix: true

  validates :topic, presence: true, inclusion: { in: TOPIC_LABELS.keys }
  validates :fingerprint, presence: true, uniqueness: true

  after_create_commit :broadcast_updates

  def self.topic_options
    TOPIC_LABELS.to_a
  end

  def self.topic_label(topic_key)
    TOPIC_LABELS.fetch(topic_key.to_s, topic_key.to_s.humanize)
  end

  def self.tallies
    grouped_counts = group(:topic).count

    TOPIC_LABELS.keys.index_with { |topic_key| grouped_counts[topic_key].to_i }
  end

  def self.total_votes
    count
  end

  def self.recent_feed(limit = 6)
    order(created_at: :desc).limit(limit)
  end

  private

  def broadcast_updates
    broadcast_replace_to(
      STREAM_KEY,
      target: "community_pulse_totals",
      partial: "community_pulse_votes/totals",
      locals: {
        tallies: self.class.tallies,
        total_votes: self.class.total_votes
      }
    )

    broadcast_replace_to(
      STREAM_KEY,
      target: "community_pulse_recent",
      partial: "community_pulse_votes/recent",
      locals: {
        votes: self.class.recent_feed
      }
    )
  end
end
