class RemoveTransactionDataFromBids < ActiveRecord::Migration
  def change
  	remove_column :bids, :order_id
  	remove_column :bids, :carrier_code
  	remove_column :bids, :tracking_num
  	remove_column :bids, :carrier
  	remove_column :bids, :delivered
		remove_column :bids, :shipment_desc
  end
end
