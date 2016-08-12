class AddResaleToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :resale_yes, :boolean
    add_column :auctions, :resale_no, :boolean
    add_column :auctions, :resale_status, :string
  end
end
