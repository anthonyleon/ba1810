class AddAttributesToParts < ActiveRecord::Migration
  def change
    add_column :parts, :cage_code, :string
    add_column :parts, :model, :string
    add_column :parts, :nsn, :string
    remove_column :parts, :manufacturer_price, :integer
  end
end
