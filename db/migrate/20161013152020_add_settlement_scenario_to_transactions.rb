class AddSettlementScenarioToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :dispute_settlement, :boolean
  end
end
