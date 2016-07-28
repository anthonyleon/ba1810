class Bid < ActiveRecord::Base
  belongs_to :company
  belongs_to :auction
  belongs_to :inventory_part
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :notifications

  def seller
    company
  end

  def buyer
    auction.company
  end

  def self.owned_bids(bids)
    auctions = []
    if bids
      bids.each do |bid|
        auctions << bid.auction if bid.auction.active
      end
      auctions.uniq!
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
