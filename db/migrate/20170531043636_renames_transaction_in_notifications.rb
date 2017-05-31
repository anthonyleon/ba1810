class RenamesTransactionInNotifications < ActiveRecord::Migration
  def change
  	rename_column :notifications, :transaction_id, :tx_id
  end
end
