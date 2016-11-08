class AuctionPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :auction

  def self.make(part, auction)
	  self.create(
	            part_num: 			part[:part_num],
	            init_price: 		part[:manufacturer_price],
	            description: 		part[:description],
	            manufacturer: 		part[:manufacturer],
	            auction:   			auction
	            # part: 				part
	          )
	end
end
