class RemoveEstShippingFromBids < ActiveRecord::Migration
  def change
    remove_column :bids, :est_shipping_cost, :decimal
  end
end
