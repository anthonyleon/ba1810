class AddPasswordResetToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :password_reset_token, :string
    add_column :companies, :password_reset_sent_at, :datetime
  end
end
