require 'rails_helper'

feature "Creating an auction" do

	scenario "auction available in user's auctions page" do
		auction_part = create(:auction_part)
		p @auction = auction_part.auction
		p @company = @auction.company
		sign_in
		visit auction_path(auction_part.auction)

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


