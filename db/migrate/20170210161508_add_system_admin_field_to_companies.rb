class AddSystemAdminFieldToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :system_admin, :boolean, default: false
  end
end
