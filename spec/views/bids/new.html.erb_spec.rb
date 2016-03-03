require 'rails_helper'

RSpec.describe "bids/new", type: :view do
  before(:each) do
    assign(:bid, Bid.new(
      :amount => "9.99",
      :company => nil,
      :auction => nil,
      :inventory_part => nil
    ))
  end

  it "renders new bid form" do
    render

    assert_select "form[action=?][method=?]", bids_path, "post" do

      assert_select "input#bid_amount[name=?]", "bid[amount]"

      assert_select "input#bid_company_id[name=?]", "bid[company_id]"

      assert_select "input#bid_auction_id[name=?]", "bid[auction_id]"

      assert_select "input#bid_inventory_part_id[name=?]", "bid[inventory_part_id]"
    end
  end
end
