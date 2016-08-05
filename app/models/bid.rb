class Bid < ActiveRecord::Base
  belongs_to :company
  belongs_to :auction
  belongs_to :inventory_part
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :notifications
  before_save :calculate_total_payment

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

  def calculate_total_payment
    part = self.part_price
    self.tax = part * 0.07
    self.armor_fee = part * 0.025
    self.bid_aero_fee = part * 0.03
    self.total_amount = part + self.tax + self.armor_fee + self.bid_aero_fee
  end
  
end
