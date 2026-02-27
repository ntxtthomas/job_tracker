class AddCareerIntelToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :fit_score, :decimal, precision: 3, scale: 2
    add_column :opportunities, :income_range_low, :integer
    add_column :opportunities, :income_range_high, :integer
    add_column :opportunities, :retirement_plan_type, :string
    add_column :opportunities, :remote_type, :string
    add_column :opportunities, :company_size, :integer
    add_column :opportunities, :risk_level, :string
    add_column :opportunities, :trajectory_score, :integer
    add_column :opportunities, :strategic_value, :integer

    add_index :opportunities, :fit_score
    add_index :opportunities, :risk_level
    add_index :opportunities, :remote_type
  end
end
