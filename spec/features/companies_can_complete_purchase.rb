require 'rails_helper'

feature 'Companies can complete checkout process' do
  let(:buyer)          { create(:company) }
  let(:seller)         { create(:company) }
  let(:part)           { create(:part) }
  let(:inventory_part) { create(:inventory_part, part: part, company: seller) }
  let(:auction)        { create(:auction, company: buyer) }
  let!(:auction_part)	 { create(:auction_part, part: part, auction: auction)}
  let!(:bid)            { create(:bid, auction: auction,
                              company: seller,
                              inventory_part: inventory_part) }

  context 'Checkout' do
    before do
      sign_in buyer
      visit auction_path(auction)
      click_button 'Checkout'
    end

  	it ' allow buyer to choose a part and checkout.' do
  		expect(page).to have_content 'Please confirm shipping address' 		
  	end

    it ' checkout should have destination fields filled' do
      expect(page).to have_field('auction[destination_company]', auction.destination_address)
      expect(page).to have_field('auction[destination_address]', with: auction.destination_address)
      expect(page).to have_field('auction[destination_city]', with: auction.destination_city)
      expect(page).to have_field('auction[destination_state]', auction.destination_state)
      expect(page).to have_field('auction[destination_zip]', with: auction.destination_zip)
      expect(page).to have_field('auction[destination_country]', with: auction.destination_country)
    end

  	
  end

end
