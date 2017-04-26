class AddTagDateToBids < ActiveRecord::Migration
  def change
  	add_column :bids, :tag_date, :date
  end
end
