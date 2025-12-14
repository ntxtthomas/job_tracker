class AddOtherTechStackToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :other_tech_stack, :text
  end
end
