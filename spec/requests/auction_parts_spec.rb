require 'rails_helper'

RSpec.describe "AuctionParts", type: :request do
  describe "GET /auction_parts" do
    it "works! (now write some real specs)" do
      get auction_parts_path
      expect(response).to have_http_status(200)
    end
  end
end
