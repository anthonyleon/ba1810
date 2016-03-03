require 'rails_helper'

RSpec.describe "inventory_parts/show", type: :view do
  before(:each) do
    @inventory_part = assign(:inventory_part, InventoryPart.create!(
      :part_num => "Part Num",
      :description => "Description",
      :manufacturer => "Manufacturer",
      :company => nil,
      :part => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Part Num/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Manufacturer/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
