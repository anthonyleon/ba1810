class AddDataToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :carrier_code, :string
  	add_column :transactions, :tracking_num, :string
  	add_column :transactions, :carrier, :string
  	add_column :transactions, :shipment_desc, :string
  	add_column :transactions, :delivered, :boolean
  	add_column :transactions, :paid, :boolean
  end
end
