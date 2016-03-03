require 'rails_helper'

RSpec.describe "inventory_parts/edit", type: :view do
  before(:each) do
    @inventory_part = assign(:inventory_part, InventoryPart.create!(
      :part_num => "MyString",
      :description => "MyString",
      :manufacturer => "MyString",
      :company => nil,
      :part => nil
    ))
  end

  it "renders the edit inventory_part form" do
    render

    assert_select "form[action=?][method=?]", inventory_part_path(@inventory_part), "post" do

      assert_select "input#inventory_part_part_num[name=?]", "inventory_part[part_num]"

      assert_select "input#inventory_part_description[name=?]", "inventory_part[description]"

      assert_select "input#inventory_part_manufacturer[name=?]", "inventory_part[manufacturer]"

      assert_select "input#inventory_part_company_id[name=?]", "inventory_part[company_id]"

      assert_select "input#inventory_part_part_id[name=?]", "inventory_part[part_id]"
    end
  end
end
