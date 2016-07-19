class AddTransactionIdtoBids < ActiveRecord::Migration
  def change
  	add_column :bids, :transaction_id, :integer
  end
end
