class AddDestinationToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :destination, index: true, foreign_key: true
  end
end
