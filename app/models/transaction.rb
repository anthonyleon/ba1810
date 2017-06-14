class Transaction < ActiveRecord::Base
	has_one :auction, through: :bid
  has_many :notifications
	belongs_to :bid
	belongs_to :inventory_part
  belongs_to :destination
	#armor payments $$ brackets/tiers
  TIER0 = 0
  TIER1 = 5_000
  TIER2 = 50_000
  TIER3 = 500_000
  TIER4 = 1_000_000

  enum status: [:pending_invoice, :pending_payment, :pending_shipment, :in_transit, :delivered, :completed, :disputed]

  def quantify_status
    self.class.statuses[status]
  end

	def self.create_order(bid)
		create(
			buyer_id: bid.buyer.id,
			seller_id: bid.seller.id,
			inventory_part: bid.inventory_part,
			auction_id: bid.auction.id,
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
    self.price_before_fees = price_before_fees
    self.total_amount = price_before_fees + self.total_fee
    p "#{self.armor_fee.to_f.to_s} + ARMOR FEE"
    p "#{self.bid_aero_fee.to_f.to_s} + BID AERO FEE"
    p "#{self.total_amount.to_f.to_s} + TOTAL AMOUNT"
    self.save!
  end

  def self.record(auction, bid)
    create(inventory_part: bid.inventory_part, seller_id: bid.company.id, buyer_id: auction.company.id,
           total_amount: bid.part_price, status: :completed, part_price: bid.part_price, bid: bid, auction: auction)
  end

  def seller
    bid.seller
  end

  def settlement_offer_submitted
    self.update(dispute_settlement: true)
  end

  def clear_dispute_responses
    self.update(settlement_rejected: false)
    self.update(settlement_accepted: false)
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

  def check_pricing_in_floats
    puts "Part Price \t\t -- \t" + part_price.to_f.to_s
    puts "Shipping \t\t -- \t" + final_shipping_cost.to_f.to_s
    puts "Tax \t\t\t -- \t" + tax.to_f.to_s
    puts "Price Before Fees \t -- \t" + price_before_fees.to_f.to_s
    puts "Armor Fee \t\t -- \t" + armor_fee.to_f.to_s
    puts "Bid Aero \t\t -- \t" + bid_aero_fee.to_f.to_s
    puts "Part Price \t\t -- \t" + part_price.to_f.to_s
    puts "Total Fee \t\t -- \t" + total_fee.to_f.to_s
    puts "Total Amount \t\t -- \t" + total_amount.to_f.to_s
  end

  def parse_webhook(data, bid)
    if data["api_key"]["api_key"] == ENV['ARMOR_PKEY']
      case data["event"]["type"]
      when 0  # order created
      when 2  # payments received in full
        #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
        self.update(status: :pending_shipment)
        Notification.notify(bid.seller, :payment_received, bid: bid, transaction: @transaction)
        CompanyMailer.ship_part(bid, bid.seller).deliver_later(wait_until: 1.minute.from_now)
      when 16 # order cancelled
        Notification.notify(bid.seller, :order_cancelled, bid: bid, transaction: self)
        CompanyMailer.order_cancelled(bid, bid.seller, bid.buyer)
      when 15 # shipment details added to order (testing purposes, not really but need to check later) this doesn't mean it was received does it?
        
      when 3 #goods shipped to buyer
        self.update(status: :in_transit)
        CompanyMailer.part_shipped(bid, bid.buyer, bid.tx)
      when 4 # goods received by buyer
        self.update(status: :delivered)
        CompanyMailer.shipment_received(bid, bid.seller).deliver_later(wait_until: 1.minute.from_now)
        Notification.notify(self.seller, :shipment_delivered, bid: bid, transaction: self)
        Notification.notify(self.buyer, :shipment_received, bid: bid, transaction: self)
      when 6 # order accepted (ie. funds released from buyer to seller)
        self.transfer_inventory
        self.update(status: :completed)
        # CREATE A REVIEW NOTIFICATION
        CompanyMailer.funds_released(bid, bid.seller).deliver_later(wait_until: 1.minute.from_now)
        Notification.notify(bid.seller, :funds_released, bid: bid, transaction: self)
      when 10 # dispute settlement offer has been submitted by either buyer or seller
        self.settlement_offer_submitted
        Notification.notify(self.buyer, :dispute_settlement_offer, bid: bid, transaction: self)
      when 26 #Goods inspection completed
        # we already have a funds release event
  #DISPUTES
      when 3000 # Dispute created
        self.update(status: :disputed)
        Notification.notify(bid.seller, :tx_disputed, bid: bid, transaction: self)
        # testing purposes. ALSO SEND AN EMAIL TO THE USER
      when 3003 # A counter-offer was made to this Offer
        offerer = Company.find_by(armor_user_id: data["event"]["user_id"])
        if offerer == self.seller
          oferree = self.buyer
        else
          offeree = self.seller
        end
        Notification.notify(offeree, :counter_offer, bid: bid, transaction: self)
        self.clear_dispute_responses
      when 3004 # Offer to settle dispute on order accepted
        company_accepting = Company.find_by(armor_user_id: data["event"]["user_id"])
        if company_accepting == self.seller
          company = self.buyer
        else
          company = self.seller
        end
        Notification.notify(company, :settlement_accepted, bid: bid, transaction: self)
      when 2005 #dispute escalated to arbitration
        Notification.notify(bid.seller, :arbitration_seller_notice, bid: bid, transaction: self)
        Notification.notify(bid.buyer, :arbitration_buyer_notice, bid: bid, transaction: self)
  #ACCOUNT EVENTS
      when 1001 # Bank Account details Added

      when 1002 # Bank Account Approved

      when 1003 # Bank Account Declined
      end
    end
  end
end
