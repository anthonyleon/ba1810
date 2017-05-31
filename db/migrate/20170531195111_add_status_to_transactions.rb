class AddStatusToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :status, :integer, default: 0
    remove_column :transactions, :delivered, :boolean
    remove_column :transactions, :paid, :boolean
    remove_column :transactions, :complete, :boolean
    remove_column :transactions, :shipped, :boolean
    remove_column :transactions, :disputed, :boolean
  end
end
