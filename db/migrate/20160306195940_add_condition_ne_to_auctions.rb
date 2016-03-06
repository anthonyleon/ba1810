class AddConditionNeToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :condition_ne, :boolean
    add_column :auctions, :condition_oh, :boolean
    add_column :auctions, :condition_sv, :boolean
    add_column :auctions, :condition_ar, :boolean
    add_column :auctions, :condition_sc, :boolean
  end
end
