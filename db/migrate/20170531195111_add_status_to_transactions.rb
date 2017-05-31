class AddStatusToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :status, :integer, default: 0
  end
end
