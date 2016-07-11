require 'rails_helper'

feature "User has the ability to sign out", :javascript => true do
	before do 
		sign_in
	end

	scenario "User signs outs from the dashboard" do

		find_link('Log out').click

		save_and_open_page
	end
end
