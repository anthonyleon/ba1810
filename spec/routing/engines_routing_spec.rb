require "rails_helper"

RSpec.describe EnginesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/engines").to route_to("engines#index")
    end

    it "routes to #new" do
      expect(:get => "/engines/new").to route_to("engines#new")
    end

    it "routes to #show" do
      expect(:get => "/engines/1").to route_to("engines#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/engines/1/edit").to route_to("engines#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/engines").to route_to("engines#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/engines/1").to route_to("engines#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/engines/1").to route_to("engines#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/engines/1").to route_to("engines#destroy", :id => "1")
    end

  end
end
