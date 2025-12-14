class CreateOpportunityTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_table :opportunity_technologies do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.references :technology, null: false, foreign_key: true

      t.timestamps
    end

    add_index :opportunity_technologies, [ :opportunity_id, :technology_id ], unique: true, name: "index_opp_tech_on_opp_and_tech"
  end
end
