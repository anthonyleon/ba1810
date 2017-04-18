class AddQuoteNumToBids < ActiveRecord::Migration
  def change
    add_column :bids, :quote_num, :string
    add_index :bids, :quote_num
  end
end
