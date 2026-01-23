class AddRoleTypeToOpportunities < ActiveRecord::Migration[8.0]
  def change
    add_column :opportunities, :role_type, :string, default: "software_engineer", null: false
    add_column :opportunities, :role_metadata, :jsonb, default: {}, null: false

    add_index :opportunities, :role_type
    add_index :opportunities, :role_metadata, using: :gin

    # Backfill existing records to software_engineer type
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE opportunities#{' '}
          SET role_type = 'software_engineer'
          WHERE role_type IS NULL
        SQL
      end
    end
  end
end
