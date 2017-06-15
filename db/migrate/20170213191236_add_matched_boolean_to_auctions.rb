class AddMatchedBooleanToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :matched, :boolean
  end
end
