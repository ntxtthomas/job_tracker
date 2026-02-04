# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_03_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "industry"
    t.string "location"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "linkedin"
    t.text "known_tech_stack"
    t.string "company_type"
    t.string "size"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "email"
    t.string "phone"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "linkedin"
    t.text "about"
    t.text "notes"
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "interactions", force: :cascade do |t|
    t.bigint "contact_id"
    t.bigint "company_id", null: false
    t.string "category"
    t.text "note"
    t.date "follow_up_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_interactions_on_company_id"
    t.index ["contact_id"], name: "index_interactions_on_contact_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "position_title"
    t.date "application_date"
    t.string "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "remote"
    t.string "tech_stack"
    t.string "source"
    t.string "salary_range"
    t.string "chatgpt_match"
    t.string "jobright_match"
    t.string "linkedin_match"
    t.string "listing_url"
    t.text "other_tech_stack"
    t.string "role_type", default: "software_engineer", null: false
    t.jsonb "role_metadata", default: {}, null: false
    t.index ["company_id"], name: "index_opportunities_on_company_id"
    t.index ["role_metadata"], name: "index_opportunities_on_role_metadata", using: :gin
    t.index ["role_type"], name: "index_opportunities_on_role_type"
  end

  create_table "opportunity_technologies", force: :cascade do |t|
    t.bigint "opportunity_id", null: false
    t.bigint "technology_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id", "technology_id"], name: "index_opp_tech_on_opp_and_tech", unique: true
    t.index ["opportunity_id"], name: "index_opportunity_technologies_on_opportunity_id"
    t.index ["technology_id"], name: "index_opportunity_technologies_on_technology_id"
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_technologies_on_category"
    t.index ["name"], name: "index_technologies_on_name", unique: true
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "interactions", "companies"
  add_foreign_key "interactions", "contacts"
  add_foreign_key "opportunities", "companies"
  add_foreign_key "opportunity_technologies", "opportunities"
  add_foreign_key "opportunity_technologies", "technologies"
end
