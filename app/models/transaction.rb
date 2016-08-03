class Transaction < ActiveRecord::Base
	has_one :auction
	has_one :bid
	belongs_to :inventory_part
	# confused about this association transaction has buyer and seller (testing purposes)
	has_many :companies

	def self.create_armor_order(bid)
		armor_order_id = ArmorPaymentsApi.create_order(bid)

		self.create(
			order_id: armor_order_id,
			buyer_id: bid.buyer.id,
			seller_id: bid.seller.id,
			inventory_part: bid.inventory_part,
			auction: bid.auction,
			bid: bid
			)
	end
end
