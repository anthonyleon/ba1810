FactoryGirl.define do
  factory :auction do
    part_num              "007-00210-0000"
    active                true
    quantity              1
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
