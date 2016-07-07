require 'rails_helper'

RSpec.describe "ratings/show", type: :view do
  before(:each) do
    @rating = assign(:rating, Rating.create!(
      :packaging => "Packaging",
      :timeliness => "Timeliness",
      :documentation => "Documentation",
      :bid_aero => "Bid Aero",
      :dependability => "Dependability"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Packaging/)
    expect(rendered).to match(/Timeliness/)
    expect(rendered).to match(/Documentation/)
    expect(rendered).to match(/Bid Aero/)
    expect(rendered).to match(/Dependability/)
  end
end
