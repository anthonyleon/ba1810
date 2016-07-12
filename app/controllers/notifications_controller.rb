class NotificationsController < ApplicationController
  before_action :unread, only: [:index]
  after_action :mark_as_read, only: [:index]
  def index
  	@notifications = current_user.notifications
  end


  private

  def unread
  	@notifications = current_user.notifications.where(read?: false)
  end

  def mark_as_read
  	@notifications.update_all(read?: true)
  end
end
