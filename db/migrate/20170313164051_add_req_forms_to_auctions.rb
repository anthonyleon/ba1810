class AddReqFormsToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :req_forms, :text
  end
end
