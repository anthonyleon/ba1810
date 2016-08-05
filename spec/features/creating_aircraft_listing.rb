require 'rails_helper'

feature "creating an aircraft listing", :javascript => true do
	before do 
		sign_in
	end

	scenario "User creates an aircraft listing" do 
		find_link('Aircraft Listing').click


		fill_in 'Aircraft Type', :with => "A380"
		fill_in 'MSN', :with => "no idea 2"
		fill_in 'Tail Number', :with => "123"
		fill_in 'YOB', :with => '10/12/1999'
		fill_in 'MTOW', :with => '1223'
		fill_in 'Engine Major Variant', :with => 'AA'
		fill_in 'Engine Minor Variant', :with => 'AA'
		fill_in 'APU Model', :with => 'AA'
		fill_in 'Cabin Configuration', :with => 'AA'
		choose('In Service')
		fill_in 'Current Operator', :with => 'AA'
		fill_in 'Last Operator', :with => 'fedex'
		fill_in 'Location', :with => 'Miami'
		fill_in 'Maintenance Status', :with => '1000'
		fill_in 'Available Date, DD/MM/YY', :with => "10/12/2017"
		check('For Lease')

		click_button('Create Aircraft')

		find_link('Back').click

		save_and_open_page
	end
end