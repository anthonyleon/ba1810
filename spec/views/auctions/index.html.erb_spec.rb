require 'rails_helper'

RSpec.describe "auctions/index", type: :view do
  before(:each) do
    assign(:auctions, [
      Auction.create!(
        :company => nil
      ),
      Auction.create!(
        :company => nil
      )
    ])
  end

  it "renders a list of auctions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
