class RemoveTransactionDataFromAuctions < ActiveRecord::Migration
  def change
  	remove_column :auctions, :paid
  	remove_column :auctions, :order_id
  end
end
