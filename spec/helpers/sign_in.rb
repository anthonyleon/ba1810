require 'rails_helper'
module SignInHelper 
	def sign_in
		# company = create(:company)
		visit login_path
		fill_in('login[email]', with: @company.email)
		fill_in('login[password]', with: 'password')
		click_button("Log In")
		# visit("/companies/#{@company.id}/confirm_email.#{@company.confirm_token}")
	end

	
end