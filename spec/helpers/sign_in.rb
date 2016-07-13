module SignInHelper 
	def sign_in
		@company = Company.create(name: "Hellooooo", email: 'bugger1@email.com', password: 'password')
		visit login_path
		fill_in('login[email]', with: 'bugger1@email.com')
		fill_in('login[password]', with: 'password')
		click_button("Log In")
		visit("/companies/#{@company.id}/confirm_email.#{@company.confirm_token}")
	end

	
end