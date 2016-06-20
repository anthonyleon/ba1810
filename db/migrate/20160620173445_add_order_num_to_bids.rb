class AddOrderNumToBids < ActiveRecord::Migration
  def change
    add_column :bids, :order_id, :string
  end
end
