class RemoveAndReAddSerialNumToInventoryParts < ActiveRecord::Migration
  def change
  	remove_column :inventory_parts, :serial_num, :string
  	add_column :inventory_parts, :serial_num, :string
  end
end
