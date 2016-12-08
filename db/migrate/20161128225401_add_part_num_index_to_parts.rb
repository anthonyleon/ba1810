class AddPartNumIndexToParts < ActiveRecord::Migration
  def change
    add_index :parts, :part_num
  end
end
