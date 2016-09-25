class RemoveConditionTypesFromEngines < ActiveRecord::Migration
  def change
    remove_column :engines, :new
    remove_column :engines, :overhaul
    remove_column :engines, :serviceable
    remove_column :engines, :non_serviceable
  end
end
