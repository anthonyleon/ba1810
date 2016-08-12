class AddReSaleLiscenceToCompanyDocs < ActiveRecord::Migration
  def change
    add_column :company_docs, :resale_license, :boolean
    remove_column :company_docs, :tax_license, :boolean
  end
end
