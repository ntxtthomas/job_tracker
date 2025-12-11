class RemoveWebsiteAndLinkedinFromOpportunities < ActiveRecord::Migration[8.0]
  def change
    remove_column :opportunities, :website, :string
    remove_column :opportunities, :linkedin, :string
  end
end
