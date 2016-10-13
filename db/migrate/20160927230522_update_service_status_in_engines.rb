class UpdateServiceStatusInEngines < ActiveRecord::Migration
  def change
    remove_column :engines, :in_service
    remove_column :engines, :off_service
    remove_column :engines, :current_status
    add_column :engines, :service_status, :integer
  end
end
