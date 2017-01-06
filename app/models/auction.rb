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

  def self.get_sales_opportunities(user)
    sales_opportunities = [] #make activerecord relation
    user_bids = user.bids

    user.inventory_parts.
      includes(part: :auctions).
      joins(part: {auctions: [:company]}).
      joins("LEFT OUTER JOIN bids ON bids.auction_id = auctions.id").
      joins("LEFT OUTER JOIN inventory_parts inventory_company_parts ON bids.inventory_part_id = inventory_company_parts.id").
      joins("LEFT OUTER JOIN companies companies_bids ON inventory_company_parts.company_id = companies_bids.id").
      where.not("auctions.company" => user). # user didn't create the auction
      where("companies_bids.id IS NULL or companies_bids.id != ? ", user.id). # user didn't make a bid
      distinct.
      each do |inventory_part|
        inventory_part.auctions.includes(:bids).each do |auction|
          conditions = auction.conditions
          part_matches = conditions.include?(inventory_part.condition.to_sym)
          user_has_placed_bids = (auction.bids & user_bids).present?
          any_condition = conditions[0].blank?

          if (part_matches || any_condition) && !user_has_placed_bids
            sales_opportunities << auction
          end
        end
    end
    sales_opportunities.uniq
  end

  end
