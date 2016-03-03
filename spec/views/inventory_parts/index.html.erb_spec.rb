require 'rails_helper'

RSpec.describe "inventory_parts/index", type: :view do
  before(:each) do
    assign(:inventory_parts, [
      InventoryPart.create!(
        :part_num => "Part Num",
        :description => "Description",
        :manufacturer => "Manufacturer",
        :company => nil,
        :part => nil
      ),
      InventoryPart.create!(
        :part_num => "Part Num",
        :description => "Description",
        :manufacturer => "Manufacturer",
        :company => nil,
        :part => nil
      )
    ])
  end

  it "renders a list of inventory_parts" do
    render
    assert_select "tr>td", :text => "Part Num".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Manufacturer".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
