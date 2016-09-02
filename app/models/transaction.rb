class Transaction < ActiveRecord::Base
	has_one :auction
	has_one :bid
	belongs_to :inventory_part
	# confused about this association transaction has buyer and seller (testing purposes)
	has_many :companies
	#armor payments $$ brackets/tiers
  TIER0 = 0
  TIER1 = 5_000
  TIER2 = 50_000
  TIER3 = 500_000
  TIER4 = 1_000_000

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

	def calculate_total_payment
    part = self.bid.part_price

    self.tax = part * self.tax_rate
    
    if self.bid.tx.shipping_account
    	self.final_shipping_cost = 0 
    else # testing purposes
    	self.final_shipping_cost = self.bid.est_shipping_cost
    end
    price_before_fees = part + self.tax + self.final_shipping_cost

    if price_before_fees < TIER1 #5,000
      self.bid_aero_fee = price_before_fees * 0.025
      self.armor_fee = price_before_fees * 0.015
    elsif price_before_fees < TIER2 #50,000
      self.bid_aero_fee = (price_before_fees - TIER1) * 0.015 + 125
      self.armor_fee = (price_before_fees - TIER1) * 0.01 + 75
    elsif price_before_fees < TIER3 #500,000
      self.bid_aero_fee = (price_before_fees - TIER2) * 0.0125 + 800
      self.armor_fee = (price_before_fees - TIER2) * 0.0075 + 525
    elsif price_before_fees < TIER4 #1,000,000
      self.bid_aero_fee = (price_before_fees - TIER3) * 0.0075 + 6425
      self.armor_fee = (price_before_fees - TIER3) * 0.005 + 3900
    else # anything over a million
    	self.bid_aero_fee = (price_before_fees - TIER4) * 0.0075 + 10175
    	self.armor_fee = (price_before_fees - TIER4) * 0.0035 + 6400
    end
    
    self.total_fee = self.armor_fee + self.bid_aero_fee
    self.total_amount = price_before_fees + self.total_fee
    self.save!
  end

	def transfer_inventory
		self.inventory_part.update_attribute('company_id', self.auction.company.id)
	end
end
