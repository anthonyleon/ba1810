class AddCompanyToCompanyDocs < ActiveRecord::Migration
  def change
    add_reference :company_docs, :company, index: true, foreign_key: true
  end
end
