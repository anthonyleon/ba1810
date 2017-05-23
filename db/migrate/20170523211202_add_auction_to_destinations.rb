class AddAuctionToDestinations < ActiveRecord::Migration
  def change
    add_reference :destinations, :auction, index: true, foreign_key: true
  end
end
