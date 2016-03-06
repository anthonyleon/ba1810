class AddConditionToAuctionPart < ActiveRecord::Migration
  def change
    add_column :auction_parts, :condition, :string

  end
end
