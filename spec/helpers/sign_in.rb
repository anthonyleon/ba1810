module SignInHelper 
	def sign_in
		@company = Company.create(name: "Hellooooo", email: 'bugger1@email.com', password: 'password1', user_phone: '305-878-3720')
		visit login_path
		fill_in('login[email]', with: 'bugger1@email.com')
		fill_in('login[password]', with: 'password1')
		click_button("Log In")
		visit("/companies/#{@company.id}/confirm_email.#{@company.confirm_token}")
	end

	
end