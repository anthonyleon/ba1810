class CreateInventoryParts < ActiveRecord::Migration
  def change
    create_table :inventory_parts do |t|
      t.string :part_num, null: false
      t.string :description, null: false
      t.string :manufacturer, null: false
      t.references :company, index: true, foreign_key: true
      t.references :part, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
