require 'rails_helper'

RSpec.describe "aircrafts/index", type: :view do
  before(:each) do
    assign(:aircrafts, [
      Aircraft.create!(
        :aircraft_type => "Aircraft Type",
        :msn => "Msn",
        :tail_number => "Tail Number",
        :yob => "Yob",
        :mtow => "Mtow",
        :engine_major_variant => "Engine Major Variant",
        :engine_minor_variant => "Engine Minor Variant",
        :apu_model => "Apu Model",
        :cabin_config => "Cabin Config",
        :in_service => false,
        :off_service => false,
        :current_operator => "Current Operator",
        :last_operator => "Last Operator",
        :location => "Location",
        :maintenance_status => "Maintenance Status",
        :available_date => "Available Date",
        :sale => false,
        :lease => false
      ),
      Aircraft.create!(
        :aircraft_type => "Aircraft Type",
        :msn => "Msn",
        :tail_number => "Tail Number",
        :yob => "Yob",
        :mtow => "Mtow",
        :engine_major_variant => "Engine Major Variant",
        :engine_minor_variant => "Engine Minor Variant",
        :apu_model => "Apu Model",
        :cabin_config => "Cabin Config",
        :in_service => false,
        :off_service => false,
        :current_operator => "Current Operator",
        :last_operator => "Last Operator",
        :location => "Location",
        :maintenance_status => "Maintenance Status",
        :available_date => "Available Date",
        :sale => false,
        :lease => false
      )
    ])
  end

  it "renders a list of aircrafts" do
    render
    assert_select "tr>td", :text => "Aircraft Type".to_s, :count => 2
    assert_select "tr>td", :text => "Msn".to_s, :count => 2
    assert_select "tr>td", :text => "Tail Number".to_s, :count => 2
    assert_select "tr>td", :text => "Yob".to_s, :count => 2
    assert_select "tr>td", :text => "Mtow".to_s, :count => 2
    assert_select "tr>td", :text => "Engine Major Variant".to_s, :count => 2
    assert_select "tr>td", :text => "Engine Minor Variant".to_s, :count => 2
    assert_select "tr>td", :text => "Apu Model".to_s, :count => 2
    assert_select "tr>td", :text => "Cabin Config".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Current Operator".to_s, :count => 2
    assert_select "tr>td", :text => "Last Operator".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Maintenance Status".to_s, :count => 2
    assert_select "tr>td", :text => "Available Date".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
