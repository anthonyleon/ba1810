require "rails_helper"

RSpec.describe AuctionPartsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/auction_parts").to route_to("auction_parts#index")
    end

    it "routes to #new" do
      expect(:get => "/auction_parts/new").to route_to("auction_parts#new")
    end

    it "routes to #show" do
      expect(:get => "/auction_parts/1").to route_to("auction_parts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/auction_parts/1/edit").to route_to("auction_parts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/auction_parts").to route_to("auction_parts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/auction_parts/1").to route_to("auction_parts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/auction_parts/1").to route_to("auction_parts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/auction_parts/1").to route_to("auction_parts#destroy", :id => "1")
    end

  end
end
