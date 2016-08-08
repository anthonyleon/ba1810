class AddEngineToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :engine, index: true, foreign_key: true
  end
end
