require 'rails_helper'

RSpec.describe "auction_parts/edit", type: :view do
  before(:each) do
    @auction_part = assign(:auction_part, AuctionPart.create!(
      :part_num => "MyString",
      :init_price => "9.99",
      :part => nil,
      :auction => nil
    ))
  end

  it "renders the edit auction_part form" do
    render

    assert_select "form[action=?][method=?]", auction_part_path(@auction_part), "post" do

      assert_select "input#auction_part_part_num[name=?]", "auction_part[part_num]"

      assert_select "input#auction_part_init_price[name=?]", "auction_part[init_price]"

      assert_select "input#auction_part_part_id[name=?]", "auction_part[part_id]"

      assert_select "input#auction_part_auction_id[name=?]", "auction_part[auction_id]"
    end
  end
end
