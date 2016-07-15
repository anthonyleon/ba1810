require 'rails_helper'

feature "creating a bid on an auction", :javascript => true do
	before do 
		sign_in
	end

	scenario "User can go to the current opportunities page and place a bid" do
		find_link('Current Auctions').click

		select 'CURRENT OPPORTUNITIES'


		save_and_open_page
	end
end