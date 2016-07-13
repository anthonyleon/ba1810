require 'rails_helper'

feature "User has the ability to sign out", :javascript => true do
	before do 
		sign_in
		current_opportunity
	end

	scenario "Notification should appear" do 
		save_and_open_page
	end
end


