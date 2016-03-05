class AddColumnSerialNumberToInventoryParts < ActiveRecord::Migration
  def change
    add_column :inventory_parts, :serial_num, :string, :null => false
  end
end
