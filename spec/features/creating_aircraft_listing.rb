require 'rails_helper'

feature "creating an aircraft listing", :javascript => true do
	before do 
		sign_in
	end

	scenario "User creates an aircraft listing" do 
		find_link('Aircraft Listing').click


		fill_in 'Aircraft type', :with => "A380"
		fill_in 'Msn', :with => "no idea 2"
		fill_in 'Tail number', :with => "123"
		fill_in 'Yob', :with => '10/12/1999'
		fill_in 'Mtow', :with => '1223'
		fill_in 'Engine major variant', :with => 'AA'
		fill_in 'Engine minor variant', :with => 'AA'
		fill_in 'Apu model', :with => 'AA'
		fill_in 'Cabin config', :with => 'AA'
		check('In service')
		fill_in 'Current operator', :with => 'AA'
		fill_in 'Last operator', :with => 'fedex'
		fill_in 'Location', :with => 'Miami'
		fill_in 'Maintenance status', :with => '1000'
		fill_in 'Available date', :with => "10/12/2017"
		check('For Lease')

		click_button('Create Aircraft')

		find_link('Back').click

		save_and_open_page
	end
end