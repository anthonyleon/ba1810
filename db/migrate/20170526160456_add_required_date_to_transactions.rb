class AddRequiredDateToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :required_date, :date
  end
end
