class AddPurchaseOrderNumberToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :po_num, :string
  end
end
