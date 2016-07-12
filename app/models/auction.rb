class Auction < ActiveRecord::Base
  belongs_to :company
  has_one :auction_part, dependent: :destroy
  has_many :bids, dependent: :destroy
 	has_many :notifications


end
