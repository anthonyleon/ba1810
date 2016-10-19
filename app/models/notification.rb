class Notification < ActiveRecord::Base
	belongs_to :company
	belongs_to :bid
	belongs_to :auction
  belongs_to :transaction

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

  def self.notify_of_opportunities(auction, user, message)
    parts = []
    parts = InventoryPart.where(part_num: auction.part_num).each do |part|
      parts << part if auction.condition.include?(part.condition) || auction.condition == "All Conditions"
    end
    parts.uniq! { |p| p.company_id }
    parts.each do |part|
      Notification.create(company: part.company, auction: auction, message: message) unless part.company == user
    end
  end

  def self.notify(bid, company, message)
    Notification.create(message: message, bid: bid, auction: bid.auction, company: company)
  end
end
