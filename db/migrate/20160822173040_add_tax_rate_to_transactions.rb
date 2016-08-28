class AddTaxRateToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :tax_rate, :float
  end
end
