class RemoveTransactionIdFromAuctions < ActiveRecord::Migration
  def change
  	remove_column :auctions, :transaction_id, :integer
  end
end
