class AddCompleteToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :complete, :boolean, :default => false
  end
end
