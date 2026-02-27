class CreateStarStoryOpportunities < ActiveRecord::Migration[8.0]
  def change
    create_table :star_story_opportunities do |t|
      t.references :star_story, null: false, foreign_key: true
      t.references :opportunity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
