class AddQuoteNumToBids < ActiveRecord::Migration
  def change
    add_column :bids, :reference_num, :string
    add_index :bids, :reference_num
  end
end
