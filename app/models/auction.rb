class Auction < ActiveRecord::Base
  belongs_to :company
  has_one :tx, class_name: "Transaction"#, foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_one :part, through: :auction_part
  has_many :bids, dependent: :destroy
  has_many :notifications, dependent: :destroy

  before_save :strip_whitespace
  
  serialize :condition, Array # rename auctions.condition to auctions.condition

  accepts_nested_attributes_for :tx

  
  def self.conditions
    %w(recent overhaul as_removed serviceable non_serviceable scrap)
  end

  def conditions # patch until column is renamed
    condition.to_a
  end  

  def resale_check
    if self.resale_status == "Yes"
      self.resale_yes = true
      self.resale_no = false
    else
      self.resale_no = true
      self.resale_yes = false
    end
  end

  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end

  def full_address
    return "#{self.destination_address}, #{self.destination_city} #{self.destination_state} #{self.destination_zip} #{self.destination_country}"
  end

  def semi_address
    return "#{self.destination_city} #{self.destination_state} #{self.destination_zip} #{self.destination_country}"
  end

end
