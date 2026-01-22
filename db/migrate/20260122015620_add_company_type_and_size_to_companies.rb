class AddCompanyTypeAndSizeToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :company_type, :string
    add_column :companies, :size, :integer
  end
end
