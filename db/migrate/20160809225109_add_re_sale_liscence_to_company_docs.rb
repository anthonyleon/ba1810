class AddReSaleLiscenceToCompanyDocs < ActiveRecord::Migration
  def change
    add_column :company_docs, :resale_license, :boolean
  end
end
