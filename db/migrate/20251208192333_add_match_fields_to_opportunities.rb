class AddMatchFieldsToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :salary_range, :string
    add_column :opportunities, :chatgpt_match, :string
    add_column :opportunities, :jobright_match, :string
    add_column :opportunities, :linkedin_match, :string
  end
end
