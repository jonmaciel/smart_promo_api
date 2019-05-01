# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_01_000922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auths", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id", "source_type"], name: "index_auths_on_source_id_and_source_type"
    t.index ["source_type", "source_id"], name: "index_auths_on_source_type_and_source_id"
  end

  create_table "chalange_progresses", force: :cascade do |t|
    t.integer "progress"
    t.bigint "chalange_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chalange_id"], name: "index_chalange_progresses_on_chalange_id"
    t.index ["customer_id"], name: "index_chalange_progresses_on_customer_id"
  end

  create_table "chalanges", force: :cascade do |t|
    t.string "Name"
    t.integer "geal"
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "cellphone"
    t.string "cpf"
    t.string "email"
    t.jsonb "interests"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fidelities", force: :cascade do |t|
    t.integer "type"
    t.integer "notification"
    t.boolean "active"
    t.bigint "customer_id"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_fidelities_on_customer_id"
    t.index ["partner_id"], name: "index_fidelities_on_partner_id"
  end

  create_table "founds", force: :cascade do |t|
    t.float "value"
    t.integer "status"
    t.bigint "sender_wallet_id"
    t.bigint "recipient_owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_owner_id"], name: "index_founds_on_recipient_owner_id"
    t.index ["sender_wallet_id"], name: "index_founds_on_sender_wallet_id"
  end

  create_table "partner_profiles", force: :cascade do |t|
    t.string "name"
    t.string "business"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "adress"
    t.string "cnpj"
    t.string "latitude"
    t.string "longitude"
    t.bigint "partner_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_profile_id"], name: "index_partners_on_partner_profile_id"
  end

  create_table "phones", force: :cascade do |t|
    t.string "number"
    t.integer "type"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_phones_on_partner_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "type"
    t.datetime "start_datetime"
    t.datetime "end_date_time"
    t.boolean "highlighted"
    t.float "index"
    t.boolean "active"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_promotions_on_partner_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "type"
    t.bigint "promotion_id"
    t.bigint "wallet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promotion_id"], name: "index_tickets_on_promotion_id"
    t.index ["wallet_id"], name: "index_tickets_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id", "source_type"], name: "index_wallets_on_source_id_and_source_type"
    t.index ["source_type", "source_id"], name: "index_wallets_on_source_type_and_source_id"
  end

  add_foreign_key "chalange_progresses", "chalanges"
  add_foreign_key "chalange_progresses", "customers"
  add_foreign_key "founds", "wallets", column: "recipient_owner_id"
  add_foreign_key "founds", "wallets", column: "sender_wallet_id"
  add_foreign_key "phones", "partners"
  add_foreign_key "promotions", "partners"
end
