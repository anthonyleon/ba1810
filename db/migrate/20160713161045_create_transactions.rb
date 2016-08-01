class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :order_id
      t.integer :auction_id
      t.integer :bid_id
      t.integer :inventory_part_id
      t.string :po_num
      t.string :invoice_num
      t.integer :seller_id
      t.integer :buyer_id

      t.timestamps null: false
    end
  end
end
