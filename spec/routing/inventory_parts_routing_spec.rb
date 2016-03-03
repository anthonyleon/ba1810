require "rails_helper"

RSpec.describe InventoryPartsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/inventory_parts").to route_to("inventory_parts#index")
    end

    it "routes to #new" do
      expect(:get => "/inventory_parts/new").to route_to("inventory_parts#new")
    end

    it "routes to #show" do
      expect(:get => "/inventory_parts/1").to route_to("inventory_parts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/inventory_parts/1/edit").to route_to("inventory_parts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/inventory_parts").to route_to("inventory_parts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/inventory_parts/1").to route_to("inventory_parts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/inventory_parts/1").to route_to("inventory_parts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/inventory_parts/1").to route_to("inventory_parts#destroy", :id => "1")
    end

  end
end
