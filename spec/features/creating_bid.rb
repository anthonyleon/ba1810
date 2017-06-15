require 'rails_helper'

feature "Creating a bid on an auction" do
	let(:part) do
		create(:part)
	end

	let(:buying_company) do
		company = create(:company, resale_cert: true)
		create(:inventory_part, company: company, part: part)
		company
	end

	let(:selling_company) do
		company = create(:company)
		create(:inventory_part, company: company, part: part, condition: 1)
		company
	end

	def sign_in_and_visit_and_create_auction
		sign_in buying_company
		visit new_auction_path
		find_and_fill_auction_form(submit: true, part_num: part.part_num)
	end

	def sign_in_and_visit
		sign_in selling_company
		visit current_opportunities_path
	end

	def sales_opportunity_exists?
		expect(page).to have_content(part.part_num)
		expect(page).to have_content(selling_company.inventory_parts.first.abbreviated_condition)
	end

	context "User can go to the current opportunities page and place a bid" do
		it "should be able to place a bid" do
			sign_in_and_visit_and_create_auction
			sign_out
			sign_in_and_visit
			sales_opportunity_exists?

			click_link part.part_num
			click_link 'New Bid'

			find_and_fill_bid_form
			p page.body
			save_and_open_page
		end
	end
end