class RemoveNullConstraintInInventoryParts < ActiveRecord::Migration
  def change
	  change_column :inventory_parts, :serial_num, :string, :null => false, :default => ""
	  change_column_default(:inventory_parts, :serial_num, nil)
  end
end
