class AddQuantityToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :quantity, :integer
  end
end
