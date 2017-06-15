class AddQuantityToBids < ActiveRecord::Migration
  def change
    add_column :bids, :quantity, :integer, default: 1
  end
end
