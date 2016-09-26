class UpdateConditionInAuctions < ActiveRecord::Migration
  def change
    change_column :auctions, :condition, 'integer USING CAST(condition AS integer)'
  end
end
