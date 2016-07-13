class ChangeNamingInNotifications < ActiveRecord::Migration
  def change
  	remove_column :notifications, :unread?
  end
end
