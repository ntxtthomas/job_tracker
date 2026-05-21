class CreateCommunityPulseVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :community_pulse_votes do |t|
      t.string :topic, null: false
      t.string :fingerprint, null: false

      t.timestamps
    end

    add_index :community_pulse_votes, :topic
    add_index :community_pulse_votes, :created_at
    add_index :community_pulse_votes, :fingerprint, unique: true
  end
end
