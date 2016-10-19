class Bid < ActiveRecord::Base
  belongs_to :company
  belongs_to :auction
  belongs_to :inventory_part
  has_one :tx, class_name: "Transaction", dependent: :destroy
  has_many :notifications, dependent: :destroy

  def seller
    company
  end

  def buyer
    auction.company
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
