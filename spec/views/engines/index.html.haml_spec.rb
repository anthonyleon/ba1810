require 'rails_helper'

RSpec.describe "engines/index", type: :view do
  before(:each) do
    assign(:engines, [
      Engine.create!(
        :engine_major_variant => "Engine Major Variant",
        :engine_minor_variant => "Engine Minor Variant",
        :esn => "Esn",
        :condition => "Condition",
        :new => false,
        :overhaul => false,
        :serviceable => false,
        :non_serviceable => false,
        :current_status => "Current Status",
        :in_service => false,
        :off_service => false,
        :current_operator => "Current Operator",
        :last_operator => "Last Operator",
        :location => "Location",
        :cycles_remaining => "Cycles Remaining",
        :available_date => "Available Date",
        :sale => false,
        :lease => false
      ),
      Engine.create!(
        :engine_major_variant => "Engine Major Variant",
        :engine_minor_variant => "Engine Minor Variant",
        :esn => "Esn",
        :condition => "Condition",
        :new => false,
        :overhaul => false,
        :serviceable => false,
        :non_serviceable => false,
        :current_status => "Current Status",
        :in_service => false,
        :off_service => false,
        :current_operator => "Current Operator",
        :last_operator => "Last Operator",
        :location => "Location",
        :cycles_remaining => "Cycles Remaining",
        :available_date => "Available Date",
        :sale => false,
        :lease => false
      )
    ])
  end

  it "renders a list of engines" do
    render
    assert_select "tr>td", :text => "Engine Major Variant".to_s, :count => 2
    assert_select "tr>td", :text => "Engine Minor Variant".to_s, :count => 2
    assert_select "tr>td", :text => "Esn".to_s, :count => 2
    assert_select "tr>td", :text => "Condition".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Current Status".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Current Operator".to_s, :count => 2
    assert_select "tr>td", :text => "Last Operator".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Cycles Remaining".to_s, :count => 2
    assert_select "tr>td", :text => "Available Date".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
