class AddFieldsToContacts < ActiveRecord::Migration[8.0]
  def change
    add_column :contacts, :linkedin, :string
    add_column :contacts, :about, :text
    add_column :contacts, :notes, :text
  end
end
