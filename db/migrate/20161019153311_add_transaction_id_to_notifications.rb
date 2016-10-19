class AddTransactionIdToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :transaction_id, :integer
  end
end
