require 'rails_helper'

feature 'Company accepts a bid' do
  let(:buyer)          { create(:company) }
  let(:seller)         { create(:company) }
  let(:part)           { create(:part) }
  let(:inventory_part) { create(:inventory_part, part: part, company: seller) }
  let(:auction)        { create(:auction, company: buyer) }
  # let(:bid)            { create(:bid, auction: auction,
  #                               company: seller,
  #                               inventory_part: inventory_part) }

  before do
    sign_in buyer
    visit auctions_path
  end

  it 'shows the buyer\'s auction' do
    expect(page.body).to have_content auction.part_num
  end
end
