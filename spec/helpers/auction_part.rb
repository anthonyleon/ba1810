module AuctionPartMatchHelper
	def current_opportunity
    	@part = Part.create(description: 'New', part_num: "8063-215", manufacturer: "WOODWARD", manufacturer_price: 2000)
    	@part_match = Part.find_by(part_num: "8063-215")
  end
end