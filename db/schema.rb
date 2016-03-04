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

ActiveRecord::Schema.define(version: 20160303065116) do

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

  add_index "auction_parts", ["auction_id"], name: "index_auction_parts_on_auction_id"
  add_index "auction_parts", ["part_id"], name: "index_auction_parts_on_part_id"

  create_table "auctions", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "part_num"
  end

  add_index "auctions", ["company_id"], name: "index_auctions_on_company_id"

  create_table "bids", force: :cascade do |t|
    t.decimal  "amount",            null: false
    t.integer  "company_id"
    t.integer  "auction_id"
    t.integer  "inventory_part_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id"
  add_index "bids", ["company_id"], name: "index_bids_on_company_id"
  add_index "bids", ["inventory_part_id"], name: "index_bids_on_inventory_part_id"

  create_table "companies", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "companies", ["email"], name: "index_companies_on_email", unique: true
  add_index "companies", ["name"], name: "index_companies_on_name", unique: true

  create_table "inventory_parts", force: :cascade do |t|
    t.string   "part_num",     null: false
    t.string   "description",  null: false
    t.string   "manufacturer", null: false
    t.integer  "company_id"
    t.integer  "part_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "inventory_parts", ["company_id"], name: "index_inventory_parts_on_company_id"
  add_index "inventory_parts", ["part_id"], name: "index_inventory_parts_on_part_id"

  create_table "parts", force: :cascade do |t|
    t.string   "description",        null: false
    t.string   "part_num",           null: false
    t.string   "manufacturer",       null: false
    t.decimal  "manufacturer_price", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
