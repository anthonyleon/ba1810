class AddBidIdToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :bid_id, :integer
  end
end
