class AddCompanyToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :company, index:true
  end
end
