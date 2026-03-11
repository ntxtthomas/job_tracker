class AddUniqueIndexOnCompaniesName < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE companies
      SET name = NULLIF(TRIM(REGEXP_REPLACE(name, '\\s+', ' ', 'g')), '')
      WHERE name IS NOT NULL;
    SQL

    duplicate_names = select_values(<<~SQL)
      SELECT LOWER(name)
      FROM companies
      WHERE name IS NOT NULL
      GROUP BY LOWER(name)
      HAVING COUNT(*) > 1
    SQL

    if duplicate_names.any?
      raise ActiveRecord::IrreversibleMigration,
            "Cannot add unique index on companies.name. Resolve duplicates first: #{duplicate_names.join(', ')}"
    end

    add_index :companies, "LOWER(name)", unique: true, name: "index_companies_on_lower_name"
  end

  def down
    remove_index :companies, name: "index_companies_on_lower_name"
  end
end
