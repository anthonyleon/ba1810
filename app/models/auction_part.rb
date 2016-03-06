class AuctionPart < ActiveRecord::Base
  validates :condition, presence: true
  belongs_to :part
  belongs_to :auction
end
