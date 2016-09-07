class ChangeDefaultOfResaleNoInAuctions < ActiveRecord::Migration
  def change
  	change_column :auctions, :resale_no, :boolean, :default => true
  end
end
