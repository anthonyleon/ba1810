FactoryGirl.define do
	factory :bid do
	  part_price: part
	  est_shipping_cost: shipping
	  company
	  auction
	  inventory_part
	end
end