class AddActiveToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :active, :boolean, null: false, default: true
  end
end
