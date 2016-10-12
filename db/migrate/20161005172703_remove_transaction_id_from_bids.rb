class RemoveTransactionIdFromBids < ActiveRecord::Migration
  def change
  	remove_column :bids, :transaction_id, :integer
  end
end
