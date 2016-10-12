require 'rails_helper'

feature 'Company can create an auction' do
  let(:buyer)  { create(:company) }
  let!(:part)  { create(:part) }

  before do
    sign_in buyer
    visit auctions_path
  end

  it { find_link 'New Auction' }

  it 'clicking the link displays the entire form' do
    click_link 'New Auction'
    find_auction_form
  end

  context 'filling the form with an existing part number' do
    before do
      click_link 'New Auction'
      find_auction_form submit: true
    end

    it 'creates an auction, visible to the user' do
      expect(page.body).to have_content 'Auction was successfully created.'
      page.has_content?("9000000-20004")
    end

    it 'creates an auction part belonging to matching part' do
      expect(AuctionPart.where(part: part)).to exist
    end

    it 'adds the auction part to the auction' do
      expect(AuctionPart.where(part: part).first.auction).to eq Auction.last
    end

    it 'and the acution belongs to the user' do
      expect(Auction.last.company).to eq buyer
    end
  end

  context 'filling the form with a nonexistent part number' do
    before do
      click_link 'New Auction'
      find_auction_form part_num: '12345', submit: true
    end

    it 'does not create the auction and notifies the company' do
      expect(page.body).to have_content 'That part does not exist in our database.'
    end
  end
end
