class AddDefaultsToBids < ActiveRecord::Migration
  def change
  	remove_column :bids, :invoice_num, :string
  	remove_column :bids, :company_id, :integer
  	rename_column :bids, :reference_num, :reference_num
  	change_column :bids, :reference_num, :string, default: "N/A"
  end
end
