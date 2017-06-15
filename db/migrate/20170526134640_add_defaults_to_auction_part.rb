class AddDefaultsToAuctionPart < ActiveRecord::Migration
  def change
  	change_column :auction_parts, :manufacturer, :string, default: "N/A"
  	change_column :auction_parts, :description, :string, default: "N/A"
  	remove_column :auction_parts, :init_price, :decimal
  end
end
