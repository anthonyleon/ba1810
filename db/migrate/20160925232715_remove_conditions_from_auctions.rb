class RemoveConditionsFromAuctions < ActiveRecord::Migration
  def change
    remove_column :auctions, :condition_ne
    remove_column :auctions, :condition_sc
    remove_column :auctions, :condition_sv
    remove_column :auctions, :condition_ar
    remove_column :auctions, :condition_oh
  end
end
