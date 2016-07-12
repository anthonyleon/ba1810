require 'rails_helper'

RSpec.describe "aircrafts/show", type: :view do
  before(:each) do
    @aircraft = assign(:aircraft, Aircraft.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Aircraft Type/)
    expect(rendered).to match(/Msn/)
    expect(rendered).to match(/Tail Number/)
    expect(rendered).to match(/Yob/)
    expect(rendered).to match(/Mtow/)
    expect(rendered).to match(/Engine Major Variant/)
    expect(rendered).to match(/Engine Minor Variant/)
    expect(rendered).to match(/Apu Model/)
    expect(rendered).to match(/Cabin Config/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Current Operator/)
    expect(rendered).to match(/Last Operator/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Maintenance Status/)
    expect(rendered).to match(/Available Date/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
