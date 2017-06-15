class AddNotNullToParts < ActiveRecord::Migration
  def change
  	change_column :parts, :part_num, :string, null: false
  end
end
