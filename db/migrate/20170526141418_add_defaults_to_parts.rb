class AddDefaultsToParts < ActiveRecord::Migration
  def change
  	change_column :parts, :description, :string, default: "N/A"
  	change_column :parts, :manufacturer, :string, default: "N/A"
  	change_column :parts, :cage_code, :string, default: "N/A"
  	change_column :parts, :nsn, :string, default: "N/A"
  	change_column :parts, :model, :string, default: "N/A"
  end
end
