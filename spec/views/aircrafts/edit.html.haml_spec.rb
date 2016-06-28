require 'rails_helper'

RSpec.describe "aircrafts/edit", type: :view do
  before(:each) do
    @aircraft = assign(:aircraft, Aircraft.create!(
      :aircraft_type => "MyString",
      :msn => "MyString",
      :tail_number => "MyString",
      :yob => "MyString",
      :mtow => "MyString",
      :engine_major_variant => "MyString",
      :engine_minor_variant => "MyString",
      :apu_model => "MyString",
      :cabin_config => "MyString",
      :in_service => false,
      :off_service => false,
      :current_operator => "MyString",
      :last_operator => "MyString",
      :location => "MyString",
      :maintenance_status => "MyString",
      :available_date => "MyString",
      :sale => false,
      :lease => false
    ))
  end

  it "renders the edit aircraft form" do
    render

    assert_select "form[action=?][method=?]", aircraft_path(@aircraft), "post" do

      assert_select "input#aircraft_aircraft_type[name=?]", "aircraft[aircraft_type]"

      assert_select "input#aircraft_msn[name=?]", "aircraft[msn]"

      assert_select "input#aircraft_tail_number[name=?]", "aircraft[tail_number]"

      assert_select "input#aircraft_yob[name=?]", "aircraft[yob]"

      assert_select "input#aircraft_mtow[name=?]", "aircraft[mtow]"

      assert_select "input#aircraft_engine_major_variant[name=?]", "aircraft[engine_major_variant]"

      assert_select "input#aircraft_engine_minor_variant[name=?]", "aircraft[engine_minor_variant]"

      assert_select "input#aircraft_apu_model[name=?]", "aircraft[apu_model]"

      assert_select "input#aircraft_cabin_config[name=?]", "aircraft[cabin_config]"

      assert_select "input#aircraft_in_service[name=?]", "aircraft[in_service]"

      assert_select "input#aircraft_off_service[name=?]", "aircraft[off_service]"

      assert_select "input#aircraft_current_operator[name=?]", "aircraft[current_operator]"

      assert_select "input#aircraft_last_operator[name=?]", "aircraft[last_operator]"

      assert_select "input#aircraft_location[name=?]", "aircraft[location]"

      assert_select "input#aircraft_maintenance_status[name=?]", "aircraft[maintenance_status]"

      assert_select "input#aircraft_available_date[name=?]", "aircraft[available_date]"

      assert_select "input#aircraft_sale[name=?]", "aircraft[sale]"

      assert_select "input#aircraft_lease[name=?]", "aircraft[lease]"
    end
  end
end
