class Notification < ActiveRecord::Base
	belongs_to :company
	belongs_to :bid
	belongs_to :auction
  belongs_to :tx, class_name: "Transaction"

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

  def self.notify_of_opportunities(auction, auction_creator, message)
    parts = []
    parts = InventoryPart.where(part_num: auction.part_num).each do |part|
      parts << part if auction.condition.include?(part.condition) || auction.condition == "All Conditions"
    end
    matches = parts.uniq { |p| p.company_id }
    
    matches.each do |part|
      Notification.create(company: part.company, auction: auction, message: message) unless part.company == auction_creator
      CompanyMailer.notify_of_opportunity(part.company, auction).deliver_later(wait_until: 1.minute.from_now) unless part.company == auction_creator
    end
    
    AdminMailer.no_matches_for_auction(auction_creator, auction) if matches.count == 0
  end

  def self.notify_auctioner(auction, message)
    Notification.create(company: auction.company, auction: auction, message: message)
    CompanyMailer.notify_buyer(auction.company, auction).deliver_now
  end

  def self.notify_other_bidders(auction, user, message)
    bid_collection =[]
    auction.bids.each do |bid|
      bid_collection << bid
    end
    bid_collection.uniq! { |b| b.company_id }
    bid_collection.each do |bid|
      Notification.create(company_id: bid.company.id, auction_id: auction.id, bid_id: bid.id, message: message) unless bid.company == user
      ## This e-mail isn't really necessary, it just tells a user they just 
      ## made a bid. And it's ugly.
      # CompanyMailer.place_new_bid(bid).deliver_later(wait_until: 1.minute.from_now)
    end
  end

  def self.notify(bid, company, message, opts = {})
    if transaction = opts[:transaction]
      Notification.create(message: message, bid: bid, auction: bid.auction, company: company, transaction_id: transaction.id)
    else
      Notification.create(message: message, bid: bid, auction: bid.auction, company: company)
    end
  end
end
