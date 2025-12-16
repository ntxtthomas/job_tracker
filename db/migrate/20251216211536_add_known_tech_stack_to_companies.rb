class AddKnownTechStackToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :known_tech_stack, :text
  end
end
