require 'rails_helper'

RSpec.describe "InventoryParts", type: :request do
  describe "GET /inventory_parts" do
    it "works! (now write some real specs)" do
      get inventory_parts_path
      expect(response).to have_http_status(200)
    end
  end
end
