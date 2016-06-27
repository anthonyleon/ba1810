class AddInvoiceNumberToBids < ActiveRecord::Migration
  def change
    add_column :bids, :invoice_num, :string
  end
end
