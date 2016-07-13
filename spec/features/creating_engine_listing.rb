require 'rails_helper'

feature "creating an engine listing", :javascript => true do
	before do 
		sign_in
	end

	scenario "User creates an engine listing" do 
		find_link('Engine Listing').click


		fill_in 'Engine Major Variant', :with => "No idea"
		fill_in 'Engine Minor Variant', :with => "no idea 2"
		fill_in 'ESN', :with => "123"
		choose('NE')
		choose('In Service')
		fill_in 'Current Operator', :with => 'AA'
		fill_in 'Last Operator', :with => 'fedex'
		fill_in 'Location Stored', :with => 'Miami'
		fill_in 'Disk Limiter', :with => '1000'
		fill_in 'Available Date', :with => "10/12/2017"
		check('For Sale')

		click_button('Create Engine')

		find_link('Back').click

		save_and_open_page
	end
end