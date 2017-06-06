class AddDefaultsToInventoryPart < ActiveRecord::Migration
  def change
  	change_column :inventory_parts, :part_num, :string, null: false
  	change_column :inventory_parts, :serial_num, :string, default: "N/A"
  	change_column :inventory_parts, :description, :string, default: "N/A"
  	change_column :inventory_parts, :manufacturer, :string, default: "N/A"
  end
end
