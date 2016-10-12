class ChangeConditionFormatInEngines < ActiveRecord::Migration
  def up
    change_column :engines, :condition, 'integer USING CAST(condition AS integer)'
  end

  def down
    change_column :engines, :condition, 'text USING CAST(condition AS text)'
  end
end
