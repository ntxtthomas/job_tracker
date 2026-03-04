class CreateResourceSheets < ActiveRecord::Migration[8.0]
  def change
    create_table :resource_sheets do |t|
      t.string :title, null: false
      t.string :resource_type, null: false, default: "interview_prep"
      t.string :role_type
      t.references :company, null: true, foreign_key: true
      t.references :opportunity, null: true, foreign_key: true
      t.string :version_label
      t.boolean :active, null: false, default: true

      t.text :about_me_content
      t.text :about_me_bullets
      t.text :why_company_content
      t.text :why_company_bullets
      t.text :why_me_content
      t.text :why_me_bullets
      t.text :salary_content
      t.text :salary_bullets
      t.text :notes_content
      t.text :notes_bullets

      t.timestamps
    end

    add_index :resource_sheets, :resource_type
    add_index :resource_sheets, :role_type
    add_index :resource_sheets, :active
  end
end
