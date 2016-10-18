class AddDisputeSettlementResponsesToTransaction < ActiveRecord::Migration
  def change
  	add_column :transactions, :settlement_accepted, :boolean
  	add_column :transactions, :settlement_rejected, :boolean
  end
end
