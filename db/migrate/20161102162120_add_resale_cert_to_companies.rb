class AddResaleCertToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :resale_cert, :boolean, default: :false
  end
end
