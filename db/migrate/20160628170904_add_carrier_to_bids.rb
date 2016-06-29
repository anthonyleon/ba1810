class AddCarrierToBids < ActiveRecord::Migration
  def change
    add_column :bids, :carrier, :string
  end
end
