class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :email
      t.string :phone
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
