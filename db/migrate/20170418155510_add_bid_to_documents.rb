class AddBidToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :bid, index: true, foreign_key: true
  end
end
