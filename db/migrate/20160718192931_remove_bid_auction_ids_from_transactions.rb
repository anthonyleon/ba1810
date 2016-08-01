class RemoveBidAuctionIdsFromTransactions < ActiveRecord::Migration
  def change
  	remove_column :transactions, :bid_id, :integer
  end
end
