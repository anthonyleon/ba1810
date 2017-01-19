require 'rails_helper'

feature "Creating an auction" do

	let(:part) do
		create(:part)
	end

	let(:buying_company) do
		company = create(:company, resale_cert: true)
		create(:inventory_part, company: company, part: part)
		company
	end

	def sign_in_and_visit_and_create_auction
		sign_in buying_company
		visit new_auction_path
		find_and_fill_auction_form(submit: true)
	end

	context "User looking for Part Requirement" do 
		it "should be able to create an auction" do
			sign_in_and_visit_and_create_auction
		end

		context "once created" do
			it "should show up in My Auction page" do
				sign_in_and_visit_and_create_auction
				
				expect(page).to have_content(buying_company.auctions.last.part_num)
				expect(page).to have_content(buying_company.auctions.last.condition.first.humanize)
			end
		end
	end
end


