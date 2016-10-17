class ChangeDestinationShopNamingInTransactions < ActiveRecord::Migration
  def change
  	remove_column :auctions, :destination_shop, :string
  	add_column :auctions, :destination_company, :string
  end
end
