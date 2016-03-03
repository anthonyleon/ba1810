class Auction < ActiveRecord::Base
  belongs_to :company
  has_one :auction_part
end
