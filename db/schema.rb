# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170705171433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircrafts", force: :cascade do |t|
    t.string   "aircraft_type"
    t.string   "msn"
    t.string   "tail_number"
    t.string   "yob"
    t.string   "mtow"
    t.string   "engine_major_variant"
    t.string   "engine_minor_variant"
    t.string   "apu_model"
    t.string   "cabin_config"
    t.string   "current_operator"
    t.string   "last_operator"
    t.string   "location"
    t.string   "maintenance_status"
    t.string   "available_date"
    t.boolean  "sale"
    t.boolean  "lease"
    t.integer  "company_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "service_status"
  end

  add_index "aircrafts", ["company_id"], name: "index_aircrafts_on_company_id", using: :btree

  create_table "auction_parts", force: :cascade do |t|
    t.string   "part_num"
    t.string   "description",  default: "N/A"
    t.string   "manufacturer", default: "N/A"
    t.integer  "part_id"
    t.integer  "auction_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "auction_parts", ["auction_id"], name: "index_auction_parts_on_auction_id", using: :btree
  add_index "auction_parts", ["part_id"], name: "index_auction_parts_on_part_id", using: :btree

  create_table "auctions", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "part_num",                       null: false
    t.boolean  "active",         default: true,  null: false
    t.text     "condition"
    t.boolean  "resale_yes"
    t.boolean  "resale_no",      default: true
    t.string   "resale_status"
    t.date     "required_date"
    t.string   "cycles",         default: "N/A"
    t.integer  "quantity",       default: 1
    t.string   "target_price",   default: "N/A"
    t.boolean  "matched"
    t.text     "req_forms"
    t.jsonb    "invitees",       default: {},    null: false
    t.integer  "project_id"
    t.string   "rep_name",       default: "N/A"
    t.string   "rep_phone",      default: "N/A"
    t.string   "rep_email",      default: "N/A"
    t.integer  "destination_id"
    t.string   "reference_num",  default: "N/A"
    t.integer  "company_id"
    t.integer  "user_id"
  end

  add_index "auctions", ["destination_id"], name: "index_auctions_on_destination_id", using: :btree
  add_index "auctions", ["invitees"], name: "index_auctions_on_invitees", using: :gin
  add_index "auctions", ["project_id"], name: "index_auctions_on_project_id", using: :btree
  add_index "auctions", ["reference_num"], name: "index_auctions_on_reference_num", using: :btree
  add_index "auctions", ["user_id"], name: "index_auctions_on_user_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.integer  "auction_id"
    t.integer  "inventory_part_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.decimal  "part_price"
    t.decimal  "est_shipping_cost"
    t.integer  "quantity",          default: 1
    t.string   "reference_num",     default: "N/A"
    t.date     "tag_date"
    t.text     "message"
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id", using: :btree
  add_index "bids", ["inventory_part_id"], name: "index_bids_on_inventory_part_id", using: :btree
  add_index "bids", ["reference_num"], name: "index_bids_on_reference_num", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.string   "email",                                  null: false
    t.string   "password_digest",                        null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "email_confirmed",        default: false
    t.string   "confirm_token"
    t.string   "armor_account_id"
    t.string   "phone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "ein"
    t.string   "armor_user_id"
    t.string   "representative"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "url"
    t.string   "inc_country"
    t.string   "inc_state"
    t.integer  "business_type"
    t.boolean  "payout_selected"
    t.boolean  "resale_cert",            default: false
    t.boolean  "system_admin",           default: false
    t.boolean  "temp",                   default: false
  end

  add_index "companies", ["email"], name: "index_companies_on_email", unique: true, using: :btree
  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "company_docs", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "company_id"
    t.string   "name"
    t.string   "attachment"
    t.boolean  "resale_license"
  end

  add_index "company_docs", ["company_id"], name: "index_company_docs_on_company_id", using: :btree

  create_table "destinations", force: :cascade do |t|
    t.string   "address",    default: "N/A"
    t.string   "city",       default: "N/A"
    t.string   "state",      default: "N/A"
    t.string   "country",    default: "N/A"
    t.string   "zip",        default: "N/A"
    t.string   "title",      default: "N/A"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.integer  "inventory_part_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "engine_id"
    t.integer  "aircraft_id"
    t.integer  "company_doc_id"
    t.integer  "bid_id"
  end

  add_index "documents", ["aircraft_id"], name: "index_documents_on_aircraft_id", using: :btree
  add_index "documents", ["bid_id"], name: "index_documents_on_bid_id", using: :btree
  add_index "documents", ["company_doc_id"], name: "index_documents_on_company_doc_id", using: :btree
  add_index "documents", ["engine_id"], name: "index_documents_on_engine_id", using: :btree
  add_index "documents", ["inventory_part_id"], name: "index_documents_on_inventory_part_id", using: :btree

  create_table "engines", force: :cascade do |t|
    t.string   "engine_major_variant"
    t.string   "engine_minor_variant"
    t.string   "esn"
    t.integer  "condition"
    t.string   "current_operator"
    t.string   "last_operator"
    t.string   "location"
    t.string   "cycles_remaining"
    t.string   "available_date"
    t.boolean  "sale"
    t.boolean  "lease"
    t.integer  "company_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "service_status"
  end

  add_index "engines", ["company_id"], name: "index_engines_on_company_id", using: :btree

  create_table "inventory_parts", force: :cascade do |t|
    t.string   "part_num",                     null: false
    t.string   "description",  default: "N/A"
    t.string   "manufacturer", default: "N/A"
    t.integer  "company_id"
    t.integer  "part_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "condition"
    t.string   "serial_num",   default: "N/A"
  end

  add_index "inventory_parts", ["company_id"], name: "index_inventory_parts_on_company_id", using: :btree
  add_index "inventory_parts", ["part_id"], name: "index_inventory_parts_on_part_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "auction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "invites", ["auction_id"], name: "index_invites_on_auction_id", using: :btree
  add_index "invites", ["user_id"], name: "index_invites_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.boolean  "read?",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "bid_id"
    t.integer  "auction_id"
    t.string   "message"
    t.integer  "tx_id"
    t.integer  "category"
    t.integer  "user_id"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "parts", force: :cascade do |t|
    t.string   "description",  default: "N/A", null: false
    t.string   "part_num",                     null: false
    t.string   "manufacturer", default: "N/A", null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "cage_code",    default: "N/A"
    t.string   "model",        default: "N/A"
    t.string   "nsn",          default: "N/A"
    t.boolean  "flagged"
  end

  add_index "parts", ["part_num"], name: "index_parts_on_part_num", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "reference_num",                           null: false
    t.string   "description",    default: "Not Provided"
    t.boolean  "active",         default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "resale",         default: false
    t.integer  "destination_id"
    t.integer  "user_id"
  end

  add_index "projects", ["destination_id"], name: "index_projects_on_destination_id", using: :btree
  add_index "projects", ["reference_num"], name: "index_projects_on_reference_num", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "packaging"
    t.integer  "timeliness"
    t.integer  "documentation"
    t.integer  "bid_aero"
    t.integer  "dependability"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "company_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "order_id"
    t.integer  "inventory_part_id"
    t.string   "po_num",              default: "N/A"
    t.string   "invoice_num",         default: "N/A"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "carrier_code",        default: "N/A"
    t.string   "tracking_num",        default: "N/A"
    t.string   "carrier",             default: "N/A"
    t.string   "shipment_desc",       default: "N/A"
    t.string   "shipping_account",    default: "N/A"
    t.float    "tax_rate",            default: 0.0
    t.decimal  "total_amount",        default: 0.0
    t.decimal  "tax",                 default: 0.0
    t.decimal  "armor_fee"
    t.decimal  "bid_aero_fee",        default: 0.0
    t.decimal  "final_shipping_cost", default: 0.0
    t.decimal  "total_fee",           default: 0.0
    t.decimal  "part_price",          default: 0.0
    t.integer  "bid_id"
    t.string   "dispute_id"
    t.boolean  "dispute_settlement"
    t.boolean  "settlement_accepted"
    t.boolean  "settlement_rejected"
    t.integer  "auction_id"
    t.decimal  "price_before_fees",   default: 0.0
    t.string   "required_date",       default: "N/A"
    t.integer  "destination_id"
    t.integer  "status",              default: 0
  end

  add_index "transactions", ["destination_id"], name: "index_transactions_on_destination_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "aircrafts", "companies"
  add_foreign_key "auction_parts", "auctions"
  add_foreign_key "auction_parts", "parts"
  add_foreign_key "auctions", "destinations"
  add_foreign_key "auctions", "projects"
  add_foreign_key "auctions", "users"
  add_foreign_key "bids", "auctions"
  add_foreign_key "bids", "inventory_parts"
  add_foreign_key "company_docs", "companies"
  add_foreign_key "documents", "aircrafts"
  add_foreign_key "documents", "bids"
  add_foreign_key "documents", "company_docs"
  add_foreign_key "documents", "engines"
  add_foreign_key "documents", "inventory_parts"
  add_foreign_key "engines", "companies"
  add_foreign_key "inventory_parts", "companies"
  add_foreign_key "inventory_parts", "parts"
  add_foreign_key "invites", "auctions"
  add_foreign_key "invites", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "projects", "destinations"
  add_foreign_key "projects", "users"
  add_foreign_key "transactions", "destinations"
  add_foreign_key "users", "companies"
end
