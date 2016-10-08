class ChangeConditionToStringInAuction < ActiveRecord::Migration
  def change
    change_column :auctions, :condition, :text
  end
end
