FactoryGirl.define do
  factory :destination do
    address   Faker::Address.street_address
    zip       Faker::Address.zip
    city      Faker::Address.city_suffix
    country   Faker::Address.country
    title     Faker::Address.name
  end
end
