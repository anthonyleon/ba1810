module Helpers
  def sign_in(company)
    visit login_path
    fill_in 'login[email]', with: company.email
    fill_in 'login[password]', with: 'password'
    click_button "Log In"
  end
end
