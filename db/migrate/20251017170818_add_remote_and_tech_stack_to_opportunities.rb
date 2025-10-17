class AddRemoteAndTechStackToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :remote, :boolean
    add_column :opportunities, :tech_stack, :string
  end
end
