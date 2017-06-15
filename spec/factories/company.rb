require "faker"

# t.string   "name",                                   null: false
#     t.string   "email",                                  null: false
#     t.string   "password_digest",                        null: false
#     t.datetime "created_at",                             null: false
#     t.datetime "updated_at",                             null: false
#     t.boolean  "email_confirmed",        default: false
#     t.string   "confirm_token"
#     t.string   "armor_account_id"
#     t.string   "phone"
#     t.string   "address"
#     t.string   "city"
#     t.string   "state"
#     t.string   "zip"
#     t.string   "country"
#     t.string   "ein"
#     t.string   "armor_user_id"
#     t.string   "representative"
#     t.string   "password_reset_token"
#     t.datetime "password_reset_sent_at"

FactoryGirl.define do
  factory :company do
    sequence(:name)        { |n| Faker::Name.name + n.to_s }
    sequence(:email)       { |n| Faker::Internet.safe_email + n.to_s }
    password              'password'
    password_confirmation 'password'
    email_confirmed       true
    phone                 "305-726-8857"
    address               Faker::Address.street_address
    city                  Faker::Address.city
    state                 Faker::Address.state
    zip                   Faker::Address.zip_code
    representative        Faker::Internet.user_name
    country               Faker::Address.country_code
    ein                   Faker::Company.ein
    payout_selected       true
  end
end
