class AddAttrToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :destination_address, :string
  	add_column :auctions, :destination_zip, :string
  	add_column :auctions, :destination_city, :string
  	add_column :auctions, :destination_country, :string
  	add_column :auctions, :required_date, :string
  end
end
