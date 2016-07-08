class Notification < ActiveRecord::Base
	belongs_to :company
	belongs_to :bid
	belongs_to :auction

	def self.any_unread?(user)
		notifications = user.notifications.map do |notify|
    	notify.unread?
    end
    notifications.include?(true)
	end
end
