class AddPreferredToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :preferred, :boolean, default: false, null: false
  end
end
