class ChangeDataTypeOfRequiredDateOnAuctions < ActiveRecord::Migration
  def change
  	remove_column :auctions, :required_date, :string
  	add_column :auctions, :required_date, :date
  end
end
