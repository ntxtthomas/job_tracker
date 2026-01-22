class ChangeCompanySizeToString < ActiveRecord::Migration[8.0]
  def change
    change_column :companies, :size, :string
  end
end
