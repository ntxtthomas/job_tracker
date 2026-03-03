class RefactorInterviewSessionsAndDropInteractions < ActiveRecord::Migration[8.0]
  def up
    add_reference :interview_sessions, :contact, foreign_key: true, null: true unless column_exists?(:interview_sessions, :contact_id)

    if column_exists?(:interview_sessions, :date)
      rename_column :interview_sessions, :date, :scheduled_at
      change_column :interview_sessions, :scheduled_at, :datetime
    end

    add_column :interview_sessions, :duration_minutes, :integer unless column_exists?(:interview_sessions, :duration_minutes)
    add_column :interview_sessions, :format, :string unless column_exists?(:interview_sessions, :format)
    add_column :interview_sessions, :status, :string unless column_exists?(:interview_sessions, :status)
    add_column :interview_sessions, :questions_they_asked, :text unless column_exists?(:interview_sessions, :questions_they_asked)
    add_column :interview_sessions, :questions_i_asked, :text unless column_exists?(:interview_sessions, :questions_i_asked)
    add_column :interview_sessions, :follow_ups, :text unless column_exists?(:interview_sessions, :follow_ups)
    add_column :interview_sessions, :next_steps, :text unless column_exists?(:interview_sessions, :next_steps)

    remove_column :interview_sessions, :clarity_score, :integer if column_exists?(:interview_sessions, :clarity_score)
    remove_column :interview_sessions, :questions_asked, :text if column_exists?(:interview_sessions, :questions_asked)
    remove_column :interview_sessions, :weak_areas, :text if column_exists?(:interview_sessions, :weak_areas)
    remove_column :interview_sessions, :strong_areas, :text if column_exists?(:interview_sessions, :strong_areas)
    remove_column :interview_sessions, :follow_up, :text if column_exists?(:interview_sessions, :follow_up)

    execute <<~SQL
      UPDATE interview_sessions
      SET stage = CASE stage
        WHEN 'tech_screen' THEN 'technical'
        WHEN 'peer' THEN 'panel'
        WHEN 'behavioral' THEN 'other'
        ELSE stage
      END
    SQL

    execute <<~SQL
      UPDATE interview_sessions
      SET status = 'planned'
      WHERE status IS NULL
    SQL

    execute <<~SQL
      UPDATE interview_sessions
      SET format = 'video'
      WHERE format IS NULL
    SQL

    add_index :interview_sessions, :status unless index_exists?(:interview_sessions, :status)
    add_index :interview_sessions, :scheduled_at unless index_exists?(:interview_sessions, :scheduled_at)

    drop_table :interactions if table_exists?(:interactions)
  end

  def down
    create_table :interactions do |t|
      t.references :contact, null: true, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :category
      t.text :note
      t.date :follow_up_date
      t.string :status

      t.timestamps
    end unless table_exists?(:interactions)

    remove_index :interview_sessions, :scheduled_at if index_exists?(:interview_sessions, :scheduled_at)
    remove_index :interview_sessions, :status if index_exists?(:interview_sessions, :status)

    add_column :interview_sessions, :clarity_score, :integer unless column_exists?(:interview_sessions, :clarity_score)
    add_column :interview_sessions, :questions_asked, :text unless column_exists?(:interview_sessions, :questions_asked)
    add_column :interview_sessions, :weak_areas, :text unless column_exists?(:interview_sessions, :weak_areas)
    add_column :interview_sessions, :strong_areas, :text unless column_exists?(:interview_sessions, :strong_areas)
    add_column :interview_sessions, :follow_up, :text unless column_exists?(:interview_sessions, :follow_up)

    remove_column :interview_sessions, :next_steps, :text if column_exists?(:interview_sessions, :next_steps)
    remove_column :interview_sessions, :follow_ups, :text if column_exists?(:interview_sessions, :follow_ups)
    remove_column :interview_sessions, :questions_i_asked, :text if column_exists?(:interview_sessions, :questions_i_asked)
    remove_column :interview_sessions, :questions_they_asked, :text if column_exists?(:interview_sessions, :questions_they_asked)
    remove_column :interview_sessions, :status, :string if column_exists?(:interview_sessions, :status)
    remove_column :interview_sessions, :format, :string if column_exists?(:interview_sessions, :format)
    remove_column :interview_sessions, :duration_minutes, :integer if column_exists?(:interview_sessions, :duration_minutes)

    if column_exists?(:interview_sessions, :scheduled_at)
      change_column :interview_sessions, :scheduled_at, :date
      rename_column :interview_sessions, :scheduled_at, :date
    end

    remove_reference :interview_sessions, :contact, foreign_key: true if column_exists?(:interview_sessions, :contact_id)
  end
end
