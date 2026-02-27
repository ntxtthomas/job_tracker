class AddMarketIntelToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :market_size_estimate, :text
    add_column :companies, :market_growth_rate, :string
    add_column :companies, :regulatory_environment, :string
    add_column :companies, :switching_costs, :string
    add_column :companies, :industry_volatility, :integer
    add_column :companies, :tech_disruption_risk, :integer
    add_column :companies, :personal_upside_score, :integer
    add_column :companies, :career_risk_score, :integer
  end
end
