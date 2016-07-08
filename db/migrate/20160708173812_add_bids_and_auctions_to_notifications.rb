class AddBidsAndAuctionsToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :bid_id, :integer
    add_column :notifications, :auction_id, :integer
  end
end
