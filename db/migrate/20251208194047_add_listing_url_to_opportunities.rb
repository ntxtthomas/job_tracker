class AddListingUrlToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :listing_url, :string
  end
end
