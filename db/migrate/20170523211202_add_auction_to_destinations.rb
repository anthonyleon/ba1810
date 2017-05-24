class AddAuctionToDestinations < ActiveRecord::Migration
  def change
    add_reference :auctions, :destination, index: true, foreign_key: true
  end
end
