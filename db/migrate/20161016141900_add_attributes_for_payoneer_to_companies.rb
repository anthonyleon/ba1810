class AddAttributesForPayoneerToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :url, :string
  	add_column :companies, :inc_country, :string
  	add_column :companies, :inc_state, :string
  	add_column :companies, :company_type, :string
  end
end
