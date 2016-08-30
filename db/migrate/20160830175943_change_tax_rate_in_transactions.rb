class ChangeTaxRateInTransactions < ActiveRecord::Migration
  def change
  	change_column :transactions, :tax_rate, :float, :default => 0.0
  end
end
