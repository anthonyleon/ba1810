class ChangesPartNumInAuctions < ActiveRecord::Migration
  def change
  	change_column :auctions, :part_num, :string, null: false
  end
end
