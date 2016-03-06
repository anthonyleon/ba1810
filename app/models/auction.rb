class Auction < ActiveRecord::Base
  validates :condition, presence: true
  belongs_to :company
  has_one :auction_part, dependent: :destroy
  has_many :bids, dependent: :destroy
end
