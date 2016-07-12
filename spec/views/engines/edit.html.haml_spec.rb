require 'rails_helper'

RSpec.describe "engines/edit", type: :view do
  before(:each) do
    @engine = assign(:engine, Engine.create!(
      :engine_major_variant => "MyString",
      :engine_minor_variant => "MyString",
      :esn => "MyString",
      :condition => "MyString",
      :new => false,
      :overhaul => false,
      :serviceable => false,
      :non_serviceable => false,
      :current_status => "MyString",
      :in_service => false,
      :off_service => false,
      :current_operator => "MyString",
      :last_operator => "MyString",
      :location => "MyString",
      :cycles_remaining => "MyString",
      :available_date => "MyString",
      :sale => false,
      :lease => false
    ))
  end

  it "renders the edit engine form" do
    render

    assert_select "form[action=?][method=?]", engine_path(@engine), "post" do

      assert_select "input#engine_engine_major_variant[name=?]", "engine[engine_major_variant]"

      assert_select "input#engine_engine_minor_variant[name=?]", "engine[engine_minor_variant]"

      assert_select "input#engine_esn[name=?]", "engine[esn]"

      assert_select "input#engine_condition[name=?]", "engine[condition]"

      assert_select "input#engine_new[name=?]", "engine[new]"

      assert_select "input#engine_overhaul[name=?]", "engine[overhaul]"

      assert_select "input#engine_serviceable[name=?]", "engine[serviceable]"

      assert_select "input#engine_non_serviceable[name=?]", "engine[non_serviceable]"

      assert_select "input#engine_current_status[name=?]", "engine[current_status]"

      assert_select "input#engine_in_service[name=?]", "engine[in_service]"

      assert_select "input#engine_off_service[name=?]", "engine[off_service]"

      assert_select "input#engine_current_operator[name=?]", "engine[current_operator]"

      assert_select "input#engine_last_operator[name=?]", "engine[last_operator]"

      assert_select "input#engine_location[name=?]", "engine[location]"

      assert_select "input#engine_cycles_remaining[name=?]", "engine[cycles_remaining]"

      assert_select "input#engine_available_date[name=?]", "engine[available_date]"

      assert_select "input#engine_sale[name=?]", "engine[sale]"

      assert_select "input#engine_lease[name=?]", "engine[lease]"
    end
  end
end
