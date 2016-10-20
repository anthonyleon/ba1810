class Auction < ActiveRecord::Base
  belongs_to :company
  has_one :tx, class_name: "Transaction"#, foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_many :bids, dependent: :destroy
 	has_many :notifications, dependent: :destroy

  serialize :condition, Array

  def self.conditions
    %w(recent overhaul as_removed serviceable non_serviceable scrap)
  end

  def conditions
    condition.to_a
  end

  accepts_nested_attributes_for :tx

  def resale_check
    if self.resale_status == "Yes"
      self.resale_yes = true
      self.resale_no = false
    else
      self.resale_no = true
      self.resale_yes = false
    end
  end

  def full_address
    return "#{self.destination_address}, #{self.destination_city} #{self.destination_state} #{self.destination_zip} #{self.destination_country}"
  end

  def self.get_sales_opportunities(user)
      parts = user.inventory_parts
      parts.uniq! { |part| [part[:part_num], part[:condition]] }
      sales_opportunities = []
      parts.each do |part|
        #stick auction in sales opportunities
        #if the auction is not the user's, already contains a user bid,
        #or if the auction isn't asking for the part in-question's condition
        Auction.where(part_num: part.part_num, active: true).each do |auction|
          insider_user = auction.company == user
          user_placed_bids = (auction.bids & user.bids).present?
          part_matches = auction.condition.include?(part.condition)
          sales_opportunities << auction unless insider_user || user_placed_bids || !part_matches
          sales_opportunities << auction if auction.condition == "All Conditions" && auction.company != user && !user_placed_bids
        end
      end
      sales_opportunities.uniq
    end

end
