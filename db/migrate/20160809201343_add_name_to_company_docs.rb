class AddNameToCompanyDocs < ActiveRecord::Migration
  def change
    add_column :company_docs, :name, :string
    add_column :company_docs, :attachment, :string
  end
end
