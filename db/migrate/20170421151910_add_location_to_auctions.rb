class AddLocationToAuctions < ActiveRecord::Migration
  def change
 	add_column :projects, :destination_address, :string
 	add_column :projects, :destination_zip, :string 	
 	add_column :projects, :destination_city, :string
 	add_column :projects, :destination_state, :string
 	add_column :projects, :destination_country, :string
 	add_column :projects, :resale, :boolean, default: false
  end
end
