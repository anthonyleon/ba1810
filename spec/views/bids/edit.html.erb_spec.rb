require 'rails_helper'

RSpec.describe "bids/edit", type: :view do
  before(:each) do
    @bid = assign(:bid, Bid.create!(
      :amount => "9.99",
      :company => nil,
      :auction => nil,
      :inventory_part => nil
    ))
  end

  it "renders the edit bid form" do
    render

    assert_select "form[action=?][method=?]", bid_path(@bid), "post" do

      assert_select "input#bid_amount[name=?]", "bid[amount]"

      assert_select "input#bid_company_id[name=?]", "bid[company_id]"

      assert_select "input#bid_auction_id[name=?]", "bid[auction_id]"

      assert_select "input#bid_inventory_part_id[name=?]", "bid[inventory_part_id]"
    end
  end
end
