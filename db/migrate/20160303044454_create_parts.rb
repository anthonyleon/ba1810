class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
     t.string :description, null: false
      t.string :part_num, null: false
      t.string :manufacturer, null: false
      t.decimal :manufacturer_price, null: false

      t.timestamps null: false
    end
  end
end
