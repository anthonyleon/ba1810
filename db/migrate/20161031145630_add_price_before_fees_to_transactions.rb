class AddPriceBeforeFeesToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :price_before_fees, :decimal
  end
end
