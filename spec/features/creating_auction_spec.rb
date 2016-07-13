require 'rails_helper'

feature "creating an auction", :javascript => true do
	before do 
		sign_in
		auction_part_match
	end


	scenario "allow a company to search for a part" do

		find_link('Part Search').click
		fill_in 'Part number', :with => "8063-215"
		check ("New")

		click_button "Submit"

		within('ul#mobile-demo.side-nav.fixed') do 
			find_link('Dashboard').click
		end

		within('ul#mobile-demo.side-nav.fixed') do
			find_link('Current Auctions').click
		end

		find_link('Show').click


		save_and_open_page
	end
end


