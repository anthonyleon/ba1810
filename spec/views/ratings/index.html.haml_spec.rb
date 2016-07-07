require 'rails_helper'

RSpec.describe "ratings/index", type: :view do
  before(:each) do
    assign(:ratings, [
      Rating.create!(
        :packaging => "Packaging",
        :timeliness => "Timeliness",
        :documentation => "Documentation",
        :bid_aero => "Bid Aero",
        :dependability => "Dependability"
      ),
      Rating.create!(
        :packaging => "Packaging",
        :timeliness => "Timeliness",
        :documentation => "Documentation",
        :bid_aero => "Bid Aero",
        :dependability => "Dependability"
      )
    ])
  end

  it "renders a list of ratings" do
    render
    assert_select "tr>td", :text => "Packaging".to_s, :count => 2
    assert_select "tr>td", :text => "Timeliness".to_s, :count => 2
    assert_select "tr>td", :text => "Documentation".to_s, :count => 2
    assert_select "tr>td", :text => "Bid Aero".to_s, :count => 2
    assert_select "tr>td", :text => "Dependability".to_s, :count => 2
  end
end
