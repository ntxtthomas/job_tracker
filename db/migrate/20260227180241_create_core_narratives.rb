class CreateCoreNarratives < ActiveRecord::Migration[8.0]
  def change
    create_table :core_narratives do |t|
      t.string :narrative_type, null: false
      t.string :version
      t.string :role_target
      t.text :content, null: false
      t.date :last_updated

      t.timestamps
    end

    add_index :core_narratives, [ :narrative_type, :role_target ]
    add_index :core_narratives, :narrative_type
  end
end
