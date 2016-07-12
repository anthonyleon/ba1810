class NotificationsController < ApplicationController
  before_action :unread, only: [:index]
  def index
  	
  end



  def unread
  	@notifications = current_user.notifications.where(unread?: true)
  end
end
