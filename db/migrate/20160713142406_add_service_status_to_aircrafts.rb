class AddServiceStatusToAircrafts < ActiveRecord::Migration
  def change
    add_column :aircrafts, :service_status, :string
  end
end
