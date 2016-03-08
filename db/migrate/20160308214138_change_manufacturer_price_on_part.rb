class ChangeManufacturerPriceOnPart < ActiveRecord::Migration
  def change
    change_column :parts, :manufacturer_price, :integer
  end
end
