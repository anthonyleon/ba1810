require 'rails_helper'

feature "Creating an auction" do

	scenario "allow a company to create an auction" do
		auction_part = create(:auction_part)
		p auction_part.auction
		sign_in
		visit auction_path(auction_part.auction)

		expect(page).to have_content("9000000-20004")
		expect(page).to have_content("As removed")
	end
end


