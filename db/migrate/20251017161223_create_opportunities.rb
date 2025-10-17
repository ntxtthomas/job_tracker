class CreateOpportunities < ActiveRecord::Migration[8.0]
  def change
    create_table :opportunities do |t|
      t.references :company, null: false, foreign_key: true
      t.string :position_title
      t.date :application_date
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
