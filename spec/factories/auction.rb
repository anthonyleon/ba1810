FactoryGirl.define do
  factory :auction do
    part_num              "9000000-20004"
    active                true
    condition             [:as_removed, :overhaul]
    destination_address   Faker::Address.street_address
    destination_zip       Faker::Address.zip
    destination_city      Faker::Address.city_suffix
    destination_country   Faker::Address.country
    required_date         Faker::Date.forward(23)
    # company
    # auction_part
  end
end
