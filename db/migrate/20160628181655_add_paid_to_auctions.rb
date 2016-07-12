class AddPaidToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :paid, :boolean
  end
end
