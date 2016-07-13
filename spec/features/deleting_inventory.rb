require 'rails_helper'


feature "User deletes a single line item for inventory", :javascript => true do
	before do 
		sign_in
		auction_part_match
		create_inventory
	end

	scenario "allow a company to delete a single inventory item" do
		within('ul.right.hide-on-med-and-down') do
			find_link('Inventory').click
		end
		find_link('Upload New Inventory').click

		fill_in 'Part number', :with => "8063-215"
		fill_in 'Serial number', :with => 1

		choose("New")

		click_button("Submit")

		within('ul#mobile-demo.side-nav.fixed') do
			find_link('Dashboard').click
		end

		within('ul#mobile-demo.side-nav.fixed') do
			find_link('Inventory').click
		end

		within_table('invetoryPartsDT') do
  		find_link('Delete').click
  	end


		save_and_open_page
	end
end

