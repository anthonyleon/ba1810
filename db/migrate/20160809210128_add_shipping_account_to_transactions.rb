class AddShippingAccountToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :shipping_account, :string
  end
end
