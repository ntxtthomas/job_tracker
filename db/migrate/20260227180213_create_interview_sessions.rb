class CreateInterviewSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :interview_sessions do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.string :stage, null: false
      t.date :date, null: false
      t.integer :confidence_score
      t.integer :clarity_score
      t.text :questions_asked
      t.text :weak_areas
      t.text :strong_areas
      t.text :follow_up
      t.string :overall_signal

      t.timestamps
    end

    add_index :interview_sessions, [ :opportunity_id, :date ]
    add_index :interview_sessions, :stage
    add_index :interview_sessions, :overall_signal
  end
end
