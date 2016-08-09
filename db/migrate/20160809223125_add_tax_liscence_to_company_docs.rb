class AddTaxLiscenceToCompanyDocs < ActiveRecord::Migration
  def change
    add_column :company_docs, :tax_license, :boolean
  end
end
