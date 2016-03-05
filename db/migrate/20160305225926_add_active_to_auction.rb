class AddActiveToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :active, :boolean
  end
end
