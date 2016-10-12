module Helpers
  def sign_in(company)
    visit login_path
    fill_in 'login[email]', with: company.email
    fill_in 'login[password]', with: 'password'
    click_button "Log In"
  end

  def find_auction_form(opts = {})
    part_num = opts[:part_num] || "9000000-20004"

    fill_in 'auction[part_num]', with: part_num
    fill_in 'auction[destination_company]', with: 'ABC Inc.'
    fill_in 'auction[destination_address]', with: '1234 Main Street'
    fill_in 'auction[destination_zip]', with: '12345'
    fill_in 'auction[destination_city]', with: 'New York'
    fill_in 'auction[destination_state]', with: 'NY'
    fill_in 'auction[destination_country]', with: 'United States'
    fill_in 'auction[required_date]', with: '10 October, 2016'
    find(:css, '#auction_resale_status_yes').set true
    within(:css, '.auction-condition-form') do
      find('#auction_condition_overhaul').set true
    end
    find_button 'Create Auction'

    click_button 'Create Auction' if opts[:submit]
  end
end
