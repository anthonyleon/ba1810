class RemoveDestinationStuffFromAuctions < ActiveRecord::Migration
  def change
    remove_column :auctions, :destination_address, :string
    remove_column :auctions, :destination_city, :string
    remove_column :auctions, :destination_state, :string
    remove_column :auctions, :destination_country, :string
    remove_column :auctions, :destination_zip, :string
    remove_column :auctions, :destination_company, :string
  end
end
