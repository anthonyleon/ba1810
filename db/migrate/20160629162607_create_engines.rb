class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :engine_major_variant
      t.string :engine_minor_variant
      t.string :esn
      t.string :condition
      t.boolean :new
      t.boolean :overhaul
      t.boolean :serviceable
      t.boolean :non_serviceable
      t.string :current_status
      t.boolean :in_service
      t.boolean :off_service
      t.string :current_operator
      t.string :last_operator
      t.string :location
      t.string :cycles_remaining
      t.string :available_date
      t.boolean :sale
      t.boolean :lease

      t.references :company, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
