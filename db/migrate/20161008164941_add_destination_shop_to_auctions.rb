class AddDestinationShopToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :destination_shop, :string
  end
end
