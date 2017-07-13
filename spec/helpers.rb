module Helpers
  def sign_in(company)
    visit login_path
    fill_in 'login[email]', with: company.email
    fill_in 'login[password]', with: 'password'
    click_button "Log In"
  end

  def sign_out
    click_link 'Log out'
  end

  def find_and_fill_auction_form(opts = {})
    part_num = opts[:part_num] || "9000000-20004"

    fill_in 'auction[part_num]', with: part_num
    fill_in 'auction[cycles]' , with: '9999'    
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

  def find_and_fill_inventory_part_form(opts ={})
    part_num = opts[:part_num] || "9000000-20004"

    fill_in 'inventory_part[part_num]', with: part_num
    fill_in 'inventory_part[serial_num]', with: '123456'
    find('#inventory_part_condition').find(:xpath, 'option[2]').select_option
    find_button 'Update Inventory Part'
    click_button 'Update Inventory Part' if opts[:submit]
  end

  def find_and_fill_bid_form
    fill_in 'bid[part_price]', with: 2_000
    page.find(:css, '#cursor-row').click()
    click_button 'Place bid'
  end

  def find_and_fill_checkout_page
    fill_in 'auction[destination_company]', with: "Bid Aero"
    fill_in 'auction[destination_address]', with: "123 Main Street"
    fill_in 'auction[destination_city]', with: "Miami"
    fill_in 'auction[destination_state]', with: "FL"
    fill_in 'auction[destination_zip]', with: "12345"
    fill_in 'auction[destination_country]', with: "US"
    fill_in 'auction[transactions][carrier]', with: "FedEx"
    fill_in 'auction[transactions][shipping_account]', with: "x341s1kj24124515j5k1lu1"
    click_button 'Submit'
  end
end
