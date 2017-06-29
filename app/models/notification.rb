class Notification < ActiveRecord::Base
	belongs_to :company
	belongs_to :bid
	belongs_to :auction
  belongs_to :tx, class_name: "Transaction"

  enum category: [:win, :new_quote, :competing_quote, :invite, :shipment_in_transit, :broadcast, :send_payment, :payment_received, 
                  :order_cancelled, :shipment_delivered, :shipment_received, :funds_released, :dispute_settlement_offer, :tx_disputed, 
                  :counter_offer, :settlement_accepted, :arbitration_seller_notice, :arbitration_buyer_notice]



	def self.any_unread?(user)
		notifications = user.notifications.map do |notify|
    	notify.read?
    end
    notifications.include?(false)
	end

	def self.exists?(bid, msg)
		arr = []
		Notification.where(bid: bid).each do |n|
			arr << n.message
		end
		arr.include?(msg)
	end

  def self.notify_of_opportunities(auction, auction_company, category)
    message = categorize(category)
    parts = []
    parts = InventoryPart.where(part_num: auction.part_num).each do |part|
      parts << part if auction.condition.include?(part.condition) || auction.condition == "All Conditions"
    end
    matches = parts.uniq { |p| p.company_id }
    
    matches.each do |part|
      ##dont do if company is invited to bid, it should just be one notification for the invite
      Notification.create(company: part.company, auction: auction, category: category, message: message) unless part.company == auction_company 
      CompanyMailer.notify_of_opportunity(part.company, auction).deliver_later(wait_until: 1.minute.from_now) unless part.company == auction_company
    end
    
    AdminMailer.no_matches_for_auction(auction_company, auction) if matches.count == 0
  end

  def self.notify_auctioner(auction, category)
    message = categorize(category)
    Notification.create(user: auction.user, auction: auction, message: message, category: category)
    CompanyMailer.notify_buyer(auction.company, auction).deliver_later(wait_until: 1.minute.from_now)
  end

  def self.notify_other_bidders(auction, user, category)
    message = categorize(category)
    bid_collection =[]
    auction.bids.each do |bid|
      bid_collection << bid
    end
    bid_collection.uniq! { |b| b.user }
    bid_collection.each do |bid|
      Notification.create(user: bid.user, auction: bid.auction, bid: bid, message: message, category: category) unless bid.user == user
    end
  end

  def self.categorize(category)
      case category
      when :win
        "Buyer has awarded you the winner of this eRFQ. Please finalize order details"
      when :new_quote
        "A new quote has been submitted for your review!"
      when :competing_quote
        "A competing quote has been placed on an eRFQ you are participating in!"
      when :invite
        "You have been invited to participate in an eRFQ!"
      when :shipment_in_transit
        "Shipping Info has been received, your order (##{opts[:transaction].order_id}) is in transit."
      when :broadcast
        "You have a new opportunity to sell!"
      when :send_payment
        "Seller has finalized costs. Please send funds to escrow."
      when :payment_received
        "Payment has been received in full please proceed to shipping procedure."
      when :order_cancelled
        "The order ##{@transaction.order_id} for part ##{@transaction.auction.part_num} has been cancelled."
      when :shipment_delivered
        "Buyer for order ##{@transaction.order_id}, has received shipment. Funds will be released upon approval of part."
      when :shipment_received
        "Order ##{@transaction.order_id}, has been marked as received. You have 3 days to approve part."
      when :funds_released
        "The funds for order ##{@transaction.order_id} have been released from escrow in accordance with your payout preference."
      when :dispute_settlement_offer
        "A settlement offer has been submitted to you. Please review."
      when :tx_disputed
        "Buyer for #{bid.auction.part_num}, order ##{@transaction.order_id}, has disputed the transaction."
      when :counter_offer
        "A settlement offer has been created on dispute ##{data["event"]["order_id"]}"
      when :settlement_accepted
        "Your settlement offer for order ##{@transaction.order_id} has been accepted"
      when :arbitration_seller_notice
        "Disputed Order ##{@transaction.order_num} has been escalated to arbitration."
      when :arbitration_buyer_notice
        "Disputed Order ##{@transaction.order_num} has been escalated to arbitration."
      end
  end

  def sub_message(user)
    if tx
      "by #{tx.seller == user ? tx.buyer.name : tx.seller.name}"
    elsif bid
      "by #{bid.company.name}"
    elsif auction
      "by #{auction.company.name}"
    end
  end

  def self.notify(user, category, opts = {}) 
    message = categorize(category)
    create(message: message, user: user, category: category, bid: opts[:bid], auction: opts[:auction], tx: opts[:transaction])
  end

  def link
    tx || auction || bid
  end

  def choose_icon    
    case category
      when "win"
        "icon-medal-first"
      when "new_quote"
        "icon-stack3"
      when "competing_quote"
        "icon-warning22"
      when "invite"
        "icon-envelop"
      when "shipment_in_transit"
        "icon-truck"
      when "broadcast"
        "icon-megaphone"
      when "send_payment"
        "icon-cash3"
      when "payment_received"
        "icon-cash3"
      when "order_cancelled"
        "icon-warning22"
      when "shipment_delivered"
        "icon-truck"
      when "shipment_received"
        "icon-truck"
      when "funds_released"
        "icon-coin-dollar"
      when "dispute_settlement_offer"
        "icon-folder"
      when "tx_disputed"
        "icon-warning22"
      when "counter_offer"
        "icon-folder"
      when "settlement_accepted"
        "icon-file-check2"
      when "arbitration_seller_notice"
        "icon-file-text3"
      when "arbitration_buyer_notice"
        "icon-file-text3"
    end 
  end

  def choose_color
    
    case category
      when "win"
        "bg-success-400"
      when "new_quote"
        "bg-primary-400"
      when "competing_quote"
        "bg-warning-400"
      when "invite"
        "bg-success-400"
      when "shipment_in_transit"
        "bg-primary-400"
      when "broadcast"
        "bg-success-400"
      when "send_payment"
        "bg-primary-400"
      when "payment_received"
        "bg-success-400"
      when "order_cancelled"
        "bg-warning-300"
      when "shipment_delivered"
        "bg-success-400"
      when "shipment_received"
        "bg-success-400"
      when "funds_released"
        "bg-success-400"
      when "dispute_settlement_offer"
        "bg-primary-300"
      when "tx_disputed"
        "bg-warning-300"
      when "counter_offer"
        "bg-warning-300"
      when "settlement_accepted"
        "bg-success-300"
      when "arbitration_seller_notice"
        "bg-warning-300"
      when "arbitration_buyer_notice"
        "bg-warning-300"
    end 
  end
end
