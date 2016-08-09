class CreateCompanyDocs < ActiveRecord::Migration
  def change
    create_table :company_docs do |t|

      t.timestamps null: false
    end
  end
end
