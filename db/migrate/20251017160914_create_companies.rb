class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :industry
      t.string :location
      t.string :tech_stack
      t.string :website

      t.timestamps
    end
  end
end
