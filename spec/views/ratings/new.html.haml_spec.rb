require 'rails_helper'

RSpec.describe "ratings/new", type: :view do
  before(:each) do
    assign(:rating, Rating.new(
      :packaging => "MyString",
      :timeliness => "MyString",
      :documentation => "MyString",
      :bid_aero => "MyString",
      :dependability => "MyString"
    ))
  end

  it "renders new rating form" do
    render

    assert_select "form[action=?][method=?]", ratings_path, "post" do

      assert_select "input#rating_packaging[name=?]", "rating[packaging]"

      assert_select "input#rating_timeliness[name=?]", "rating[timeliness]"

      assert_select "input#rating_documentation[name=?]", "rating[documentation]"

      assert_select "input#rating_bid_aero[name=?]", "rating[bid_aero]"

      assert_select "input#rating_dependability[name=?]", "rating[dependability]"
    end
  end
end
