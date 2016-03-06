class AddEmailConfirmToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :email_confirmed, :boolean, default: false
    add_column :companies, :confirm_token, :string
  end
end
