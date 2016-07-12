class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.string :aircraft_type
      t.string :msn
      t.string :tail_number
      t.string :yob
      t.string :mtow
      t.string :engine_major_variant
      t.string :engine_minor_variant
      t.string :apu_model
      t.string :cabin_config
      t.boolean :in_service
      t.boolean :off_service
      t.string :current_operator
      t.string :last_operator
      t.string :location
      t.string :maintenance_status
      t.string :available_date
      t.boolean :sale
      t.boolean :lease

      t.references :company, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
