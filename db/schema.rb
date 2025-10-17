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

ActiveRecord::Schema[8.0].define(version: 2025_10_17_194016) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "industry"
    t.string "location"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "email"
    t.string "phone"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["company_id"], name: "index_opportunities_on_company_id"
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "interactions", "companies"
  add_foreign_key "interactions", "contacts"
  add_foreign_key "opportunities", "companies"
end
