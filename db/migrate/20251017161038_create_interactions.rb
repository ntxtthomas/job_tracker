class CreateInteractions < ActiveRecord::Migration[8.0]
  def change
    create_table :interactions do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :category
      t.text :note
      t.date :follow_up_date
      t.string :status

      t.timestamps
    end
  end
end
