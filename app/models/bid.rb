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
    self.tax = part * self.tx.tax_rate 
    self.shipping_cost = 0 if bid.tx.shipping_account

    price_before_fees = part + self.tax + self.shipping_cost

    if price_before_fees < 5_000
      self.total_amount = price_before_fees + price_before_fees * 0.04
    elsif price_before_fees < 50_000
      self.total_amount = price_before_fees + price_before_fees * 0.025
    elsif price_before_fees < 500_000
      self.total_amount = price_before_fees + price_before_fees * 0.0175
    elsif price_before_fees < 1_000_000
      self.total_amount = price_before_fees + price_before_fees * 0.01
    else
      self.total_amount = price_before_fees + price_before_fees * 0.006 
    end
      

    self.armor_fee = price_before_fees * 0.025 


    self.total_amount = part + self.tax + self.armor_fee + self.bid_aero_fee
  end
  
end
