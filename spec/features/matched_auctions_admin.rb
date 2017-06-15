require 'rails_helper'

feature "Sales Opportunities" do
	let(:part) do
		create(:part)
	end

	let(:admin_company) do
		company = create(:company, admin: true)
		create(:inventory_part, company: company, part: part)
		create(:inventory_part, company: company, part: second_part)
		company
	end

	def sign_in_and_visit
		sign_in admin_company
		visit matched_auctions_path
	end

	context "admin view of matched auctions" do
		context "all sales opportunities" do
			it "should show" do
				sign_in_and_visit
				p 
			end
		end		

		context "1 seller, 1 buyer, 1 part, 2 random bids" do
			it "auction is a sales opportunity" do
				2.times { create(:bid, auction: auction) } # 2 random bids
				
				sign_in_and_visit
				sales_opportunity_exists?
			end
		end
	end
end
