class AddActiveToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :active, :boolean, default: true
  end
end
