require 'rails_helper'


feature 'Potential seller creates a bid' do
  let(:buyer)          { create(:company) }
  let(:seller)         { create(:company) }
  let(:part)           { create(:part) }
  # let(:inventory_part) { create(:inventory_part, part: part, company: seller) }
  # let(:auction)        { create(:auction, company: buyer) }
  # let(:bid)            { create(:bid, auction: auction,
  #                               company: seller,
  #                               inventory_part: inventory_part) }


  context 'Company is able to create and see Inventory Part' do
    before do
      sign_in seller
      visit inventory_parts_path
      click_link 'Upload New Inventory'
      find_and_fill_inventory_part_form part_num: part.part_num, submit: true
    end

    it 'should be successfully created' do
      expect(page).to have_content 'Inventory part was successfully created'
      click_link 'Back'
      expect(page).to have_content part.part_num
    end

    it 'should belong to the company that made it' do
      expect(InventoryPart.last.company).to eq seller
    end

    it 'Inventory part shows up in inventory' do
      visit inventory_parts_path
      expect(page).to have_content part.part_num
    end
  end

  context 'Company placing bid' do
    before do
      #sign buyer in and create the auction
      sign_in buyer
      visit auctions_path
      click_link 'New Auction'
      find_auction_form part: part.part_num, submit: true
      visit logout_path

      #sign in seller and create the inventory for that seller
      sign_in seller
      visit inventory_parts_path
      click_link 'Upload New Inventory'
      find_and_fill_inventory_part_form part_num: part.part_num, submit: true
      visit auctions_path
    end

    it 'should be available in current opportunities.' do
      click_link 'Current Opportunities'
      expect(page).to have_content part.part_num
    end

    it 'should be able to place the bid, and for bid to belong to the auction' do
      click_link part.part_num
      click_link 'New Bid'
      find_and_fill_bid_form
      expect(page).to have_content seller.name
      expect(Bid.last.seller).to eq seller
      expect(Auction.last.bids).to include Bid.last
    end

  end

end
