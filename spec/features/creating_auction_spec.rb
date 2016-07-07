require 'rails_helper'

RSpec.feature "creating an auction" do
	scenario "allow a company to search for a part" do 

		visit new_auction_path

		fill_in 'Part number', with: "8063-215"
		check ("New")

		expect(page)
	end
end
