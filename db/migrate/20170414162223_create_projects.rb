class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :reference_num
      t.text :description
      t.boolean :active, default: true

      t.timestamps null: false
    end

    add_index :projects, [:reference_num]
  end
end
