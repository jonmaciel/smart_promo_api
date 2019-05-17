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

ActiveRecord::Schema.define(version: 2019_05_14_000826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auths", force: :cascade do |t|
    t.boolean "adm", default: false, null: false
    t.string "email"
    t.string "cellphone_number"
    t.string "password_digest", null: false
    t.string "source_type"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id", "source_type"], name: "index_auths_on_source_id_and_source_type"
    t.index ["source_type", "source_id"], name: "index_auths_on_source_type_and_source_id"
  end

  create_table "challenge_progresses", force: :cascade do |t|
    t.integer "progress"
    t.bigint "challenge_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_progresses_on_challenge_id"
    t.index ["customer_id"], name: "index_challenge_progresses_on_customer_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "name"
    t.integer "goal"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.jsonb "interests"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", force: :cascade do |t|
    t.float "value"
    t.integer "status"
    t.bigint "sender_wallet_id"
    t.bigint "recipient_owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_owner_id"], name: "index_funds_on_recipient_owner_id"
    t.index ["sender_wallet_id"], name: "index_funds_on_sender_wallet_id"
  end

  create_table "loyalties", force: :cascade do |t|
    t.integer "type"
    t.boolean "active", default: true
    t.boolean "notification", default: true
    t.bigint "customer_id"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "partner_id"], name: "index_loyalties_on_customer_id_and_partner_id"
    t.index ["customer_id"], name: "index_loyalties_on_customer_id"
    t.index ["partner_id"], name: "index_loyalties_on_partner_id"
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
    t.string "number"
    t.string "complementary_address"
    t.string "latitude"
    t.string "longitude"
    t.bigint "partner_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_profile_id"], name: "index_partners_on_partner_profile_id"
  end

  create_table "phones", force: :cascade do |t|
    t.string "number"
    t.integer "kind"
    t.bigint "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_phones_on_partner_id"
  end

  create_table "promotion_types", force: :cascade do |t|
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.boolean "highlighted"
    t.float "index"
    t.boolean "active"
    t.bigint "partner_id"
    t.bigint "promotion_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_promotions_on_partner_id"
    t.index ["promotion_type_id"], name: "index_promotions_on_promotion_type_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "value"
    t.bigint "partner_id", null: false
    t.bigint "promotion_type_id", null: false
    t.bigint "wallet_id"
    t.bigint "promotion_contempled_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_tickets_on_partner_id"
    t.index ["promotion_contempled_id"], name: "index_tickets_on_promotion_contempled_id"
    t.index ["promotion_type_id"], name: "index_tickets_on_promotion_type_id"
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

  add_foreign_key "challenge_progresses", "challenges"
  add_foreign_key "challenge_progresses", "customers"
  add_foreign_key "funds", "wallets", column: "recipient_owner_id"
  add_foreign_key "funds", "wallets", column: "sender_wallet_id"
  add_foreign_key "phones", "partners"
  add_foreign_key "promotions", "partners"
  add_foreign_key "tickets", "promotions", column: "promotion_contempled_id"
end
