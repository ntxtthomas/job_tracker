class RemoveTechStackFromCompanies < ActiveRecord::Migration[8.0]
  def change
    remove_column :companies, :tech_stack, :string
  end
end
