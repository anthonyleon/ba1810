class AddPayoutSelectedToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :payout_selected, :boolean
  end
end
