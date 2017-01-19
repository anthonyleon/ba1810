class Auction < ActiveRecord::Base
  belongs_to :company
  has_one :tx, class_name: "Transaction"#, foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_one :part, through: :auction_part
  has_many :bids, dependent: :destroy
  has_many :notifications, dependent: :destroy

  before_save :strip_whitespace
  before_save :upcase_part_num
  
  serialize :condition, Array # rename auctions.condition to auctions.condition

  accepts_nested_attributes_for :tx

  
  def self.conditions
    %i(recent overhaul as_removed serviceable non_serviceable scrap)
  end

  def conditions # patch until column is renamed
    condition.to_a
  end  

  def resale_check
    if resale_status == "Yes"
      resale_yes = true
      resale_no = false
    else
      resale_no = true
      resale_yes = false
    end
  end

  def upcase_part_num
    part_num.upcase!
  end

  def strip_whitespace
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end

  def full_address
    "#{destination_address}, #{destination_city.capitalize}, #{destination_state.upcase} #{destination_zip} #{destination_country.upcase}"
  end

  def semi_address
    "#{destination_city.capitalize}, #{destination_state.upcase} #{destination_zip} #{destination_country.upcase}"
  end

end
