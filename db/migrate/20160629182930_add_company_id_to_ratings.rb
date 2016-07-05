class AddCompanyIdToRatings < ActiveRecord::Migration
  def change
  	add_column :ratings, :company_id, :integer
  end
end
