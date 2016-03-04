class CreateAuctionParts < ActiveRecord::Migration
  def change
    create_table :auction_parts do |t|
      t.string :part_num
      t.string :description
      t.string :manufacturer
      t.decimal :init_price
      t.references :part, index: true, foreign_key: true
      t.references :auction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
