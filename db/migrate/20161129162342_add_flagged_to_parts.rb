class AddFlaggedToParts < ActiveRecord::Migration
  def change
    add_column :parts, :flagged, :boolean
  end
end
