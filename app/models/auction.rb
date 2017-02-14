class Auction < ActiveRecord::Base
  belongs_to :company
  has_one :tx, class_name: "Transaction"#, foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_one :part, through: :auction_part
  has_many :bids, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :quantity, presence: true

  before_save :strip_whitespace
  before_save :upcase_part_num
  
  serialize :condition, Array # rename auctions.condition to auctions.condition

  accepts_nested_attributes_for :tx

  
  def self.conditions
    %w(recent overhaul as_removed serviceable non_serviceable scrap)
  end

  def conditions # patch until column is renamed
    condition.to_a
  end  

  def self.active
    where(active: true)
  end

  def self.companies_w_auctions
    Company.joins(:auctions).where(auctions: {active: true}).select("DISTINCT companies.*")
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


  def self.part_match_or_not_actions(auction, part_match)
    #part_match is for Parts Table
    if part_match
      AdminMailer.new_auction(auction).deliver_now
      AuctionPart.make(part_match, auction)
    end
      
  #if the part for the RFQ doesn't match a part in our parts_db
    if !part_match
      AdminMailer.no_part_match(auction).deliver_now
      AuctionPart.temporary_make(auction)
    end

  # For InventoryPart check if auction matches one
    part = InventoryPart.where.not(company: auction.company).where(part_num: auction.part_num)
    if !part.empty?
      auction.update_attribute('matched', true)
    else
      auction.update_attribute('matched', false)
    end
  end

def self.define_matched_auctions(auction)
      part = InventoryPart.where.not(company: auction.company).where(part_num: auction.part_num)
    if !part.empty?
      auction.update_attribute('matched', true)
    else
      auction.update_attribute('matched', false)
    end
end
  def full_address
    "#{destination_address}, #{destination_city.capitalize}, #{destination_state.upcase} #{destination_zip} #{destination_country.upcase}"
  end

  def semi_address
    "#{destination_city.capitalize}, #{destination_state.upcase} #{destination_zip} #{destination_country.upcase}"
  end

end
