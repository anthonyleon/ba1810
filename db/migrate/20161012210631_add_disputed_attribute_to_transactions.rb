class AddDisputedAttributeToTransactions < ActiveRecord::Migration
  def change
      add_column :transactions, :disputed, :boolean
      add_column :transactions, :dispute_id, :string
  end
end
