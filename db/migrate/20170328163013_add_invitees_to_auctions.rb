class AddInviteesToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :invitees, :text
  end
end
