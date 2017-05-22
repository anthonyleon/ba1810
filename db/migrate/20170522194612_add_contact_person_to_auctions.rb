class AddContactPersonToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :rep_name, :string
    add_column :auctions, :rep_phone, :string
    add_column :auctions, :rep_email, :string
  end
end
