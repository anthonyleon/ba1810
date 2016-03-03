require 'rails_helper'

RSpec.describe "auctions/edit", type: :view do
  before(:each) do
    @auction = assign(:auction, Auction.create!(
      :company => nil
    ))
  end

  it "renders the edit auction form" do
    render

    assert_select "form[action=?][method=?]", auction_path(@auction), "post" do

      assert_select "input#auction_company_id[name=?]", "auction[company_id]"
    end
  end
end
