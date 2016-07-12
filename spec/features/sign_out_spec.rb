require 'rails_helper'

feature "User has the ability to sign out", :javascript => true do
	before do 
		sign_in
	end

	scenario "User signs out by clicking the buttom on the TOP NAVBAR" do
		within('ul.right.hide-on-med-and-down') do
			find_link('Log out').click
		end
	end

	scenario "User signs outs by clicking the button on the SIDE NAVBAR" do
		within('ul#mobile-demo.side-nav.fixed') do
			find_link('Log out').click
		end
	end


end
