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

ActiveRecord::Schema[8.1].define(version: 2026_05_05_000006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "associations", force: :cascade do |t|
    t.integer "association_id", null: false
    t.integer "count", default: 1
    t.datetime "created_at", null: false
    t.boolean "fill_in", default: false
    t.boolean "gmaps"
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.boolean "scrubbed", default: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "user_word", default: false
    t.integer "word_id", null: false
    t.index ["association_id"], name: "index_associations_on_association_id"
    t.index ["word_id", "association_id"], name: "index_associations_on_word_id_and_association_id", unique: true
    t.index ["word_id"], name: "index_associations_on_word_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.text "comments"
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
  end

  create_table "user_associations", force: :cascade do |t|
    t.integer "association_id", null: false
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.boolean "gmaps"
    t.float "latitude"
    t.float "longitude"
    t.string "postal_code"
    t.string "region"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "word_id", null: false
    t.index ["user_id"], name: "index_user_associations_on_user_id"
    t.index ["word_id"], name: "index_user_associations_on_word_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "postal_code"
    t.string "region"
    t.string "role", default: "user"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "webauthn_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["webauthn_id"], name: "index_users_on_webauthn_id", unique: true
  end

  create_table "webauthn_credentials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.string "nickname"
    t.text "public_key", null: false
    t.bigint "sign_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["external_id"], name: "index_webauthn_credentials_on_external_id", unique: true
    t.index ["user_id"], name: "index_webauthn_credentials_on_user_id"
  end

  create_table "words", force: :cascade do |t|
    t.integer "associations_count", default: 0
    t.datetime "created_at", null: false
    t.integer "depth"
    t.boolean "fill_in", default: false
    t.integer "flagged", default: 0
    t.boolean "gmaps"
    t.boolean "got", default: false
    t.datetime "last_grabbed"
    t.float "latitude"
    t.integer "lft"
    t.float "longitude"
    t.string "name", null: false
    t.integer "parent_id"
    t.integer "r_rated", default: 0
    t.integer "rgt"
    t.boolean "scrubbed", default: false
    t.integer "tasks_count", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "user_word", default: false
    t.index ["name"], name: "index_words_on_name", unique: true
  end

  add_foreign_key "webauthn_credentials", "users"
end
