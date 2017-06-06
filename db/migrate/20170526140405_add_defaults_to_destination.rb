class AddDefaultsToDestination < ActiveRecord::Migration
  def change
  	change_column :destinations, :title, :string, default: "N/A"
  	change_column :destinations, :address, :string, default: "N/A"
  	change_column :destinations, :city, :string, default: "N/A"
  	change_column :destinations, :state, :string, default: "N/A"
  	change_column :destinations, :country, :string, default: "N/A"
  	change_column :destinations, :zip, :string, default: "N/A"
  end
end
