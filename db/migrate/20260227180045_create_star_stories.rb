class CreateStarStories < ActiveRecord::Migration[8.0]
  def change
    create_table :star_stories do |t|
      t.string :title, null: false
      t.text :situation
      t.text :task
      t.text :action
      t.text :result
      t.string :skills, array: true, default: []
      t.string :category
      t.integer :strength_score
      t.integer :times_used, default: 0
      t.date :last_used_at
      t.string :outcome
      t.text :notes

      t.timestamps
    end

    add_index :star_stories, :category
    add_index :star_stories, :skills, using: :gin
    add_index :star_stories, :strength_score
  end
end
