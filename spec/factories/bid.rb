FactoryGirl.define do
  factory :bid do
    part_price        900
    est_shipping_cost 45
    company
    auction
    inventory_part
  end
end
