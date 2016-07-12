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

		save_and_open_page
	end
end


