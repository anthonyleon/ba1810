require 'rails_helper'

RSpec.describe "auction_parts/show", type: :view do
  before(:each) do
    @auction_part = assign(:auction_part, AuctionPart.create!(
      :part_num => "Part Num",
      :init_price => "9.99",
      :part => nil,
      :auction => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Part Num/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
