class AddStateToAuctions < ActiveRecord::Migration
  def change
  	add_column :auctions, :destination_state, :string
  end
end
