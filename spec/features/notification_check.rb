require 'rails_helper'

feature "User has the ability to sign out", :javascript => true do
	before do 
		sign_in
		current_opportunity
	end

	scenario "Notification should appear" do 
		within('ul.right.hide-on-med-and-down') do 
			find(:css, 'material-icons').click
			save_and_open_page
		end
	end
end


	