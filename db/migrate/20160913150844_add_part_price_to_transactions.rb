class AddPartPriceToTransactions < ActiveRecord::Migration
  def change
  	add_column  :transactions, :part_price, :decimal
  end
end
