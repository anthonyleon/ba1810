class AuctionPart < ActiveRecord::Base
  belongs_to :part
  belongs_to :auction
end
