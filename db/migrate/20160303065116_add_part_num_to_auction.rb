class AddPartNumToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :part_num, :string
  end
end
