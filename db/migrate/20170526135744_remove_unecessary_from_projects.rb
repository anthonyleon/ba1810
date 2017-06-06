class RemoveUnecessaryFromProjects < ActiveRecord::Migration
  def change
  	remove_column :projects, :destination_address, :string
  	remove_column :projects, :destination_city, :string
  	remove_column :projects, :destination_state, :string
  	remove_column :projects, :destination_country, :string
  	remove_column :projects, :destination_zip, :string
  end
end
