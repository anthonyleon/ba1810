class AddDefaultsToAuctions < ActiveRecord::Migration
  def change
  	change_column :auctions, :rep_name, :string, default: "N/A"
  	change_column :auctions, :rep_phone, :string, default: "N/A"
  	change_column :auctions, :rep_email, :string, default: "N/A"
  	change_column :auctions, :reference_num, :string, default: "N/A"
  	change_column :auctions, :target_price, :string, default: "N/A"
  	change_column :auctions, :quantity, :integer, default: 1
  	change_column :auctions, :cycles, :string, default: "N/A"
  	change_column :auctions, :rep_name, :string, default: "N/A"
  	remove_column :auctions, :po_num, :string
  end
end
