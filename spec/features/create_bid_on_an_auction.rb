require 'rails_helper'

feature 'Potential seller creates a bid' do
  # let(:buyer)          { create(:company) }
  let(:seller)         { create(:company) }
  let(:part)           { create(:part) }
  let(:inventory_part) { create(:inventory_part, part: part, company: seller) }
  # let(:auction)        { create(:auction, company: buyer) }
  # let(:bid)            { create(:bid, auction: auction,
  #                               company: seller,
  #                               inventory_part: inventory_part) }

  before do
    sign_in seller
    visit inventory_parts_path
    # click_link('Current Opportunities')
    # find('.part_num', match: :first).click
    binding.pry
  end

  it 'Inventory part shows up in inventory' do
  	page.has_content? inventory_part.part_num
  	# save_and_open_page
  	# click_link inventory_part.part_num

  end

  # it 'shows the buyer\'s auction' do
  #   expect(page.body).to have_content auction.part_num
  # end
end