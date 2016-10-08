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

ActiveRecord::Schema.define(version: 20161005172703) do

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
    t.string   "description"
    t.string   "manufacturer"
    t.decimal  "init_price"
    t.integer  "part_id"
    t.integer  "auction_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "auction_parts", ["auction_id"], name: "index_auction_parts_on_auction_id", using: :btree
  add_index "auction_parts", ["part_id"], name: "index_auction_parts_on_part_id", using: :btree

  create_table "auctions", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "part_num"
    t.boolean  "active",              default: true, null: false
    t.text     "condition"
    t.string   "po_num"
    t.string   "destination_address"
    t.string   "destination_zip"
    t.string   "destination_city"
    t.string   "destination_country"
    t.string   "required_date"
    t.string   "destination_state"
    t.boolean  "resale_yes"
    t.boolean  "resale_no",           default: true
    t.string   "resale_status"
  end

  add_index "auctions", ["company_id"], name: "index_auctions_on_company_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "auction_id"
    t.integer  "inventory_part_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "invoice_num"
    t.decimal  "part_price"
    t.decimal  "est_shipping_cost"
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id", using: :btree
  add_index "bids", ["company_id"], name: "index_bids_on_company_id", using: :btree
  add_index "bids", ["inventory_part_id"], name: "index_bids_on_inventory_part_id", using: :btree

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
    t.string   "EIN"
    t.string   "armor_user_id"
    t.string   "representative"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
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

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.integer  "inventory_part_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "engine_id"
    t.integer  "aircraft_id"
    t.integer  "company_doc_id"
  end

  add_index "documents", ["aircraft_id"], name: "index_documents_on_aircraft_id", using: :btree
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
    t.string   "part_num",     null: false
    t.string   "description"
    t.string   "manufacturer"
    t.integer  "company_id"
    t.integer  "part_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "serial_num",   null: false
    t.integer  "condition"
  end

  add_index "inventory_parts", ["company_id"], name: "index_inventory_parts_on_company_id", using: :btree
  add_index "inventory_parts", ["part_id"], name: "index_inventory_parts_on_part_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.boolean  "read?",      default: false
    t.integer  "company_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "bid_id"
    t.integer  "auction_id"
    t.string   "message"
  end

  create_table "parts", force: :cascade do |t|
    t.string   "description",        null: false
    t.string   "part_num",           null: false
    t.string   "manufacturer",       null: false
    t.integer  "manufacturer_price", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

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
    t.string   "po_num"
    t.string   "invoice_num"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "carrier_code"
    t.string   "tracking_num"
    t.string   "carrier"
    t.string   "shipment_desc"
    t.boolean  "delivered"
    t.boolean  "paid"
    t.string   "shipping_account"
    t.float    "tax_rate",            default: 0.0
    t.decimal  "total_amount"
    t.decimal  "tax"
    t.decimal  "armor_fee"
    t.decimal  "bid_aero_fee"
    t.decimal  "final_shipping_cost"
    t.decimal  "total_fee"
    t.boolean  "complete",            default: false
    t.decimal  "part_price"
    t.boolean  "shipped"
    t.integer  "bid_id"
  end

  add_foreign_key "aircrafts", "companies"
  add_foreign_key "auction_parts", "auctions"
  add_foreign_key "auction_parts", "parts"
  add_foreign_key "auctions", "companies"
  add_foreign_key "bids", "auctions"
  add_foreign_key "bids", "companies"
  add_foreign_key "bids", "inventory_parts"
  add_foreign_key "company_docs", "companies"
  add_foreign_key "documents", "aircrafts"
  add_foreign_key "documents", "company_docs"
  add_foreign_key "documents", "engines"
  add_foreign_key "documents", "inventory_parts"
  add_foreign_key "engines", "companies"
  add_foreign_key "inventory_parts", "companies"
  add_foreign_key "inventory_parts", "parts"
end
