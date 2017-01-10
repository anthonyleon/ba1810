class AuctionPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :auction
  validates :part, :auction, presence: true

  def self.make(part, auction)
	  create(
	            part_num: 			part[:part_num], # this should be delegated to self.part
	            init_price: 		part[:manufacturer_price],
	            description: 		part[:description],
	            manufacturer: 		part[:manufacturer],
	            auction:   			auction,
	            part: 				part
	          )
	end

	def self.temporary_make(auction)
		part = Part.create(part_num: auction.part_num, description: "", manufacturer: "", flagged: true)

		create(
		        part_num: 			part[:part_num], # this should be delegated to self.part
		        auction:   			auction,
		        part: 				part
		      )
	end

	def part_num
		part.part_num
	end
end
