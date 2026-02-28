class AddBusFactorToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :bus_factor, :integer
  end
end
