class AddCompanyDocToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :company_doc, index: true, foreign_key: true
  end
end
