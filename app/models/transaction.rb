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

	def self.create_order(bid)

		self.create(
			buyer_id: bid.buyer.id,
			seller_id: bid.seller.id,
			inventory_part: bid.inventory_part,
			auction: bid.auction,
			bid: bid,
      part_price: bid.part_price
			)
	end

	def calculate_total_payment
    part = self.part_price

    self.tax = part * (self.tax_rate / 100)
    p "#{self.part_price.to_f.to_s}"
    p "#{self.tax_rate.to_f.to_s} + tax_rate"
    p "#{self.tax.to_f.to_s} + TAX"

    if self.shipping_account
    	self.final_shipping_cost = 0 
    end

    p "#{self.final_shipping_cost.to_f.to_s} + FINAL SHIPPPING COST"
    price_before_fees = part + self.tax + self.final_shipping_cost
    p "#{price_before_fees.to_f.to_s} + PRICE BEFORE FEES"
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
    p self.armor_fee.to_f.to_s
    self.armor_fee = 10 if self.armor_fee < 10
    
    self.total_fee = self.armor_fee + self.bid_aero_fee
    self.total_amount = price_before_fees + self.total_fee
    p "#{self.armor_fee.to_f.to_s} + ARMOR FEE"
    p "#{self.bid_aero_fee.to_f.to_s} + BID AERO FEE"
    p "#{self.total_amount.to_f.to_s} + TOTAL AMOUNT"
    self.save!
  end

  def completed
    self.complete = true
    self.save!
  end
  
  def payment_received
    self.paid = true
    self.save!
  end

  def delivery_received
    self.delivered = true
    self.save!
  end

  def seller
    bid.seller
  end

  def buyer
    self.bid.buyer
  end

  def part
    bid.inventory_part
  end

  def create_armor_order
    self.order_id = ArmorPaymentsApi.create_order(self.bid)
    self.save!
  end

	def transfer_inventory
		self.inventory_part.update_attribute('company_id', nil)
	end
end
