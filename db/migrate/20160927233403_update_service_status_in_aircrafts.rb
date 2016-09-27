class UpdateServiceStatusInAircrafts < ActiveRecord::Migration
  def change
    remove_column :aircrafts, :in_service
    remove_column :aircrafts, :off_service
    change_column :aircrafts, :service_status, 'integer USING CAST(service_status AS integer)'
  end
end
