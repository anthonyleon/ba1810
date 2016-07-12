class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :packaging
      t.integer :timeliness
      t.integer :documentation
      t.integer :bid_aero
      t.integer :dependability

      t.timestamps null: false
    end
  end
end
