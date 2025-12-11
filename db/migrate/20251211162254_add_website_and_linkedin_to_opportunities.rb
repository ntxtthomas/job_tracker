class AddWebsiteAndLinkedinToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :website, :string
    add_column :opportunities, :linkedin, :string
  end
end
