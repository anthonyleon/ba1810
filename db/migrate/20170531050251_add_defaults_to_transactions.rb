class AddDefaultsToTransactions < ActiveRecord::Migration
  def change
  	change_column :transactions, :total_amount, :decimal, default: 0
  	change_column :transactions, :tax, :decimal, default: 0
  	change_column :transactions, :bid_aero_fee, :decimal, default: 0
  	change_column :transactions, :final_shipping_cost, :decimal, default: 0
  	change_column :transactions, :total_fee, :decimal, default: 0
  	change_column :transactions, :part_price, :decimal, default: 0
  	change_column :transactions, :price_before_fees, :decimal, default: 0
  end
end
