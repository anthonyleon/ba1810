class AddAircraftToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :aircraft, index: true, foreign_key: true
  end
end
