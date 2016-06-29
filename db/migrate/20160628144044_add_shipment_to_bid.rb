class AddShipmentToBid < ActiveRecord::Migration
  def change
    add_column :bids, :carrier_code, :string
    add_column :bids, :tracking_num, :string
    add_column :bids, :shipment_desc, :text
  end
end
