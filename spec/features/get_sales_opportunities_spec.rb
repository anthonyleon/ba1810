require 'rails_helper'

feature "Getting Sales Opportunities" do

	scenario "sales opportunities w/ no bids available in user's sales opportunities view" do
		auction_part = create(:auction_part)
		@auction = auction_part.auction
		p @company = @auction.company
		# @potential_seller = create(:company)

		inventory_part = create(:inventory_part)
		p "*" * 80
		p @potential_seller = inventory_part.company

		p @potential_seller.inventory_parts
		sign_in @potential_seller
		visit current_opportunities_path

		expect(page).to have_content("9000000-20004")
		expect(page).to have_content("As removed")
		expect(@auction).to eql(@company.auctions.last)



		bid = create(:bid)
		@company = bid.company

		sign_in

		expect(@auction.bids).to include(bid)
	end

	scenario "Creating a bid" do
		
	end
end
