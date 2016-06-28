class AddOrderNumToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :order_id, :string
  end
end
