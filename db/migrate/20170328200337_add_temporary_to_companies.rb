class AddTemporaryToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :temp, :boolean, default: false
  end
end
