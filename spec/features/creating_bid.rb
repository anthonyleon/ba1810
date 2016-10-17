require 'rails_helper'

feature "Creating a bid on an auction" do

	scenario "User can go to the current opportunities page and place a bid" do

		find_link('Current Auctions').click
		within('#currentOpportunities.col.s12') do
			find_link('CURRENT OPPORTUNITIES').click
		end
	end



	
end