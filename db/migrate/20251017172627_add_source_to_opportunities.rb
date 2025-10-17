class AddSourceToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :source, :string
  end
end
