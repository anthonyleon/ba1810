class AddMoreDefaultsToTransactions < ActiveRecord::Migration
  def change
  	change_column :transactions, :po_num, :string, default: "N/A"
  	change_column :transactions, :invoice_num, :string, default: "N/A"
  	change_column :transactions, :carrier_code, :string, default: "N/A"
  	change_column :transactions, :tracking_num, :string, default: "N/A"
  	change_column :transactions, :carrier, :string, default: "N/A"
  	change_column :transactions, :shipment_desc, :string, default: "N/A"
  	change_column :transactions, :shipping_account, :string, default: "N/A"
  	change_column :transactions, :required_date, :string, default: "N/A"
  end
end
