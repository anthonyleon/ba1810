class Auction < ActiveRecord::Base
  belongs_to :company
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_many :bids, dependent: :destroy
 	has_many :notifications


end
