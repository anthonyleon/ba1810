class ChangeConditionFormatInInventoryParts < ActiveRecord::Migration
  def up
    change_column :inventory_parts, :condition, 'integer USING CAST(condition AS integer)'
  end

  def down
    change_column :inventory_parts, :condition, 'text USING CAST(condition AS text)'
  end
end
