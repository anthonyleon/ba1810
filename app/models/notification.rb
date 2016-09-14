class Notification < ActiveRecord::Base
	belongs_to :company
	belongs_to :bid
	belongs_to :auction

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

end
