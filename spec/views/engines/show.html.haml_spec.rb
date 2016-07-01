require 'rails_helper'

RSpec.describe "engines/show", type: :view do
  before(:each) do
    @engine = assign(:engine, Engine.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Engine Major Variant/)
    expect(rendered).to match(/Engine Minor Variant/)
    expect(rendered).to match(/Esn/)
    expect(rendered).to match(/Condition/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Current Status/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Current Operator/)
    expect(rendered).to match(/Last Operator/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Cycles Remaining/)
    expect(rendered).to match(/Available Date/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
