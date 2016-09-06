class AddPricingFieldsToBids < ActiveRecord::Migration
  def change
  	remove_column :bids, :amount, :decimal
  	add_column :bids, :part_price, :decimal
  	add_column :bids, :shipping_cost, :decimal
  	add_column :bids, :tax, :decimal
  	add_column :bids, :armor_fee, :decimal
  	add_column :bids, :bid_aero_fee, :decimal
  	add_column :bids, :part_price, :decimal
  end
end
