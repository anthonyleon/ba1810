class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.string :title

      t.timestamps null: false
    end
  end
end
