class AddLinkedinToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :linkedin, :string
  end
end
