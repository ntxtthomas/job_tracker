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

ActiveRecord::Schema[8.0].define(version: 2026_02_28_015924) do
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
    t.text "primary_product"
    t.string "revenue_model"
    t.string "funding_stage"
    t.string "estimated_revenue"
    t.integer "estimated_employees"
    t.string "growth_signal"
    t.integer "product_maturity"
    t.integer "engineering_maturity"
    t.integer "process_maturity"
    t.string "market_position"
    t.string "competitor_tier"
    t.integer "brand_signal_strength"
    t.text "market_size_estimate"
    t.string "market_growth_rate"
    t.string "regulatory_environment"
    t.string "switching_costs"
    t.integer "industry_volatility"
    t.integer "tech_disruption_risk"
    t.integer "personal_upside_score"
    t.integer "career_risk_score"
    t.index ["funding_stage"], name: "index_companies_on_funding_stage"
    t.index ["growth_signal"], name: "index_companies_on_growth_signal"
    t.index ["industry"], name: "index_companies_on_industry"
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

  create_table "core_narratives", force: :cascade do |t|
    t.string "narrative_type", null: false
    t.string "version"
    t.string "role_target"
    t.text "content", null: false
    t.date "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["narrative_type", "role_target"], name: "index_core_narratives_on_narrative_type_and_role_target"
    t.index ["narrative_type"], name: "index_core_narratives_on_narrative_type"
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

  create_table "interview_sessions", force: :cascade do |t|
    t.bigint "opportunity_id", null: false
    t.string "stage", null: false
    t.date "date", null: false
    t.integer "confidence_score"
    t.integer "clarity_score"
    t.text "questions_asked"
    t.text "weak_areas"
    t.text "strong_areas"
    t.text "follow_up"
    t.string "overall_signal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id", "date"], name: "index_interview_sessions_on_opportunity_id_and_date"
    t.index ["opportunity_id"], name: "index_interview_sessions_on_opportunity_id"
    t.index ["overall_signal"], name: "index_interview_sessions_on_overall_signal"
    t.index ["stage"], name: "index_interview_sessions_on_stage"
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
    t.decimal "fit_score", precision: 3, scale: 2
    t.integer "income_range_low"
    t.integer "income_range_high"
    t.string "retirement_plan_type"
    t.string "remote_type"
    t.integer "company_size"
    t.string "risk_level"
    t.integer "trajectory_score"
    t.integer "strategic_value"
    t.integer "bus_factor"
    t.index ["company_id"], name: "index_opportunities_on_company_id"
    t.index ["fit_score"], name: "index_opportunities_on_fit_score"
    t.index ["remote_type"], name: "index_opportunities_on_remote_type"
    t.index ["risk_level"], name: "index_opportunities_on_risk_level"
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

  create_table "star_stories", force: :cascade do |t|
    t.string "title", null: false
    t.text "situation"
    t.text "task"
    t.text "action"
    t.text "result"
    t.string "skills", default: [], array: true
    t.string "category"
    t.integer "strength_score"
    t.integer "times_used", default: 0
    t.date "last_used_at"
    t.string "outcome"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_star_stories_on_category"
    t.index ["skills"], name: "index_star_stories_on_skills", using: :gin
    t.index ["strength_score"], name: "index_star_stories_on_strength_score"
  end

  create_table "star_story_opportunities", force: :cascade do |t|
    t.bigint "star_story_id", null: false
    t.bigint "opportunity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id"], name: "index_star_story_opportunities_on_opportunity_id"
    t.index ["star_story_id"], name: "index_star_story_opportunities_on_star_story_id"
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
  add_foreign_key "interview_sessions", "opportunities"
  add_foreign_key "opportunities", "companies"
  add_foreign_key "opportunity_technologies", "opportunities"
  add_foreign_key "opportunity_technologies", "technologies"
  add_foreign_key "star_story_opportunities", "opportunities"
  add_foreign_key "star_story_opportunities", "star_stories"
end
