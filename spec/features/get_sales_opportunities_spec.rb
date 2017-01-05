require 'rails_helper'

feature "Getting Sales Opportunities" do

	scenario "sales opportunities w/ NO bids available in user's sales opportunities view" do
		db_part = create(:part)

		auction = create(:auction)
		auction_part = auction.auction_part
		auction_part.update(part: db_part)

		buyer = auction.company

		inventory_part = create(:inventory_part)
		inventory_part.update(part: db_part)
		potential_seller = inventory_part.company
		parts = potential_seller.inventory_parts


 		sign_in potential_seller
		visit current_opportunities_path

		expect(page).to have_content("9000000-20004")
		expect(page).to have_content("AR")
		expect(auction).to eql(buyer.auctions.last)
	end

	scenario "sales opportunities w/ bids (including one posted by current_user) shouldn't be showing on current opportunities" do

		random_bid = create(:bid)
		auction = create(:auction)
		random_bid.update(auction: auction)

		buyer = auction.company

		inventory_part = create(:inventory_part)
		current_user = inventory_part.company

		current_user_bid = create(:bid)
		current_user_bid.update(company: current_user)
		current_user_bid.update(auction: auction)

		sign_in current_user

		visit current_opportunities_path

		expect(page).to have_no_content("9000000-20004")
		expect(auction).to eql(buyer.auctions.last)
	end

	scenario "sales opportunities w/ bids not posted by current user should appear in Current Opportuntities" do
		first_bid = create(:bid)
		auction = create(:auction)
		first_bid.update(auction: auction)
		
		second_bid = create(:bid)
		second_bid = create(:bid)

		inventory_part = create(:inventory_part)
		current_user = inventory_part.company

		sign_in current_user

		visit current_opportunities_path

		expect(page).to have_content("9000000-20004")
		expect(page).to have_content("AR")
	end
end
