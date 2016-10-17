class RenameEin < ActiveRecord::Migration
  def change
  	rename_column :companies, :EIN, :ein
  end
end
