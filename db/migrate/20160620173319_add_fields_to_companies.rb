class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :armor_account_id, :string
    add_column :companies, :phone, :string
    add_column :companies, :address, :string
    add_column :companies, :city, :string
    add_column :companies, :state, :string
    add_column :companies, :zip, :string
    add_column :companies, :country, :string
    add_column :companies, :EIN, :string
    add_column :companies, :armor_user_id, :string
  end
end
