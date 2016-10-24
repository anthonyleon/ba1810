class ChangeCompanyTypeToIntInCompanies < ActiveRecord::Migration
  def change
  	remove_column :companies, :company_type, :string
  	add_column :companies, :business_type, :integer
  end
end
