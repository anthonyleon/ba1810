class AddTransactionIdtoAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :transaction_id, :integer
  end
end
