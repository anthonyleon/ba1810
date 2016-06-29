class AddDeliveredToBids < ActiveRecord::Migration
  def change
    add_column :bids, :delivered, :boolean
  end
end
