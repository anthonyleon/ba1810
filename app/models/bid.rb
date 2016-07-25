class Bid < ActiveRecord::Base
  belongs_to :company
  belongs_to :auction
  belongs_to :inventory_part
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :notifications

  def self.supplier_auctions user_bids
    auctions = []
    if user_bids
      user_bids.each do |bid|
        auctions.push(bid.auction) if bid.auction.active
      end
      auctions.uniq! || auctions
    end
  end

 def average_rating
    arr = []
    company.ratings.each do |rating|
        arr << rating.timeliness
        arr << rating.documentation
        arr << rating.packaging
        arr << rating.dependability
    end
    arr.compact!
    (arr.sum / arr.count.to_f) unless arr.empty?
  end
  
end
