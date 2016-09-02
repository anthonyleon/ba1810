class RemoveAdditionalCostsFromBids < ActiveRecord::Migration
  def change
  	remove_column :bids, :total_amount, :decimal
  	remove_column :bids, :shipping_cost, :decimal
  	remove_column :bids, :tax, :decimal
  	remove_column :bids, :armor_fee, :decimal
  	remove_column :bids, :bid_aero_fee, :decimal

  	add_column :transactions, :total_amount, :decimal
  	add_column :transactions, :tax, :decimal
  	add_column :transactions, :armor_fee, :decimal
  	add_column :transactions, :bid_aero_fee, :decimal
  	add_column :transactions, :final_shipping_cost, :decimal
    add_column :transactions, :total_fee, :decimal
    
  	add_column :bids, :est_shipping_cost, :decimal
  	
  end
end
