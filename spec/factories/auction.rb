FactoryGirl.define do
  factory :auction do
    part_num              "007-00210-0000"
    active                true
    quantity              1
    condition             [:as_removed, :overhaul]
    required_date         Faker::Date.forward(23)
    destination
    # company
    # auction_part
  end
end
