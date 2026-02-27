class AddIntelligenceToCompanies < ActiveRecord::Migration[8.0]
  def change
    # industry already exists, skip it
    add_column :companies, :primary_product, :text
    add_column :companies, :revenue_model, :string
    add_column :companies, :funding_stage, :string
    add_column :companies, :estimated_revenue, :string
    add_column :companies, :estimated_employees, :integer
    add_column :companies, :growth_signal, :string
    add_column :companies, :product_maturity, :integer
    add_column :companies, :engineering_maturity, :integer
    add_column :companies, :process_maturity, :integer
    add_column :companies, :market_position, :string
    add_column :companies, :competitor_tier, :string
    add_column :companies, :brand_signal_strength, :integer

    add_index :companies, :industry
    add_index :companies, :funding_stage
    add_index :companies, :growth_signal
  end
end
