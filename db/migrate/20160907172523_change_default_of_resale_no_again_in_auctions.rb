class ChangeDefaultOfResaleNoAgainInAuctions < ActiveRecord::Migration
  def change
  	change_column :auctions, :resale_no, :boolean
  end
end
