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

ActiveRecord::Schema.define(version: 2021_09_14_005815) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affordances", force: :cascade do |t|
    t.bigint "place_id"
    t.integer "position", default: 0
    t.string "name"
    t.bigint "connection_id"
    t.index ["connection_id"], name: "index_affordances_on_connection_id"
    t.index ["place_id"], name: "index_affordances_on_place_id"
  end

  create_table "basecamp_sessions", force: :cascade do |t|
    t.string "token"
    t.boolean "authenticated", default: false
    t.bigint "account_id"
    t.bigint "pitch_project_id"
    t.bigint "pitch_deck_id"
    t.bigint "pitch_category_id"
    t.bigint "user_id"
    t.bigint "domain_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain_id"], name: "index_basecamp_sessions_on_domain_id"
    t.index ["user_id"], name: "index_basecamp_sessions_on_user_id"
  end

  create_table "breadboards", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.bigint "domain_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain_id"], name: "index_breadboards_on_domain_id"
    t.index ["user_id"], name: "index_breadboards_on_user_id"
  end

  create_table "cycles", force: :cascade do |t|
    t.integer "number", null: false
    t.bigint "published_id"
    t.bigint "domain_id"
    t.date "date", null: false
    t.jsonb "voting_data_hash"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain_id"], name: "index_cycles_on_domain_id"
  end

  create_table "domains", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "places", force: :cascade do |t|
    t.bigint "breadboard_id"
    t.string "name"
    t.integer "position", default: 1
    t.index ["breadboard_id"], name: "index_places_on_breadboard_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "failed_attempts", default: 0
    t.integer "sign_in_count", default: 0
    t.datetime "locked_at"
    t.string "last_seen_from_ip_address"
    t.datetime "last_seen_at"
    t.datetime "accepted_privacy_policy_at"
    t.boolean "domain_admin", default: false
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "domain_id"
    t.integer "theme", default: 0
    t.index ["domain_id"], name: "index_users_on_domain_id"
  end

  add_foreign_key "affordances", "places"
  add_foreign_key "affordances", "places", column: "connection_id"
  add_foreign_key "basecamp_sessions", "domains"
  add_foreign_key "basecamp_sessions", "users"
  add_foreign_key "breadboards", "domains"
  add_foreign_key "breadboards", "users"
  add_foreign_key "cycles", "domains"
  add_foreign_key "places", "breadboards"
  add_foreign_key "users", "domains"
end
