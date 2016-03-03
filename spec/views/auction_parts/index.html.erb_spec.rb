require 'rails_helper'

RSpec.describe "auction_parts/index", type: :view do
  before(:each) do
    assign(:auction_parts, [
      AuctionPart.create!(
        :part_num => "Part Num",
        :init_price => "9.99",
        :part => nil,
        :auction => nil
      ),
      AuctionPart.create!(
        :part_num => "Part Num",
        :init_price => "9.99",
        :part => nil,
        :auction => nil
      )
    ])
  end

  it "renders a list of auction_parts" do
    render
    assert_select "tr>td", :text => "Part Num".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
