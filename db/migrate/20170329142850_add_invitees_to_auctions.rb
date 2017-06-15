class AddInviteesToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :invitees, :jsonb, null: false, default: '{}'
    add_index  :auctions, :invitees, using: :gin
  end
end
