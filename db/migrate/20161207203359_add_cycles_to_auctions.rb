class AddCyclesToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :cycles, :string
  end
end
