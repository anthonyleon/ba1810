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
  	it ' allow buyer to choose a part and checkout.' do
  		sign_in buyer
  		visit auction_path(auction)
  		expect(page).to have_content seller.name
  		click_button 'Checkout'
  		save_and_open_page
  		
  	end

  	
  end

end
