class AddConditionToInventoryPart < ActiveRecord::Migration
  def change
    add_column :inventory_parts, :condition, :string
  end
end
