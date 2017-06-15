class AddReferenceNumToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :reference_num, :string
    add_index :auctions, :reference_num
  end
end
