class AddTargetPriceToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :target_price, :string
  end
end
