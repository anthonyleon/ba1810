class Invite < ActiveRecord::Base
  has_one	 :company, through: :user
  belongs_to :auction
  belongs_to :user
end
