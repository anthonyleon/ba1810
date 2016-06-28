class AddRepresentativeToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :representative, :string
  end
end
