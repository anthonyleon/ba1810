class Auction < ActiveRecord::Base
  belongs_to :company
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_many :bids, dependent: :destroy
 	has_many :notifications

  def condition_match
      condition = ["NE", "OH", "SV", "AR", "SC"]
      
      condition.delete("NE") if !self.condition_ne
        
      condition.delete("OH") if !self.condition_oh
        
      condition.delete("SV") if !self.condition_sv
        
      condition.delete("AR") if !self.condition_ar
        
      condition.delete("SC") if !self.condition_sc

      if condition.count == 5
        self.update(condition: "All Conditions")
      else
        self.update(condition: condition.to_sentence)
      end
      condition
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


  def full_address
    return "#{self.destination_address}, #{self.destination_city} #{self.destination_state} #{self.destination_zip} #{self.destination_country}"
  end

  def self.get_sales_opportunities(user)
      parts = user.inventory_parts
      parts.uniq! { |part| [part[:part_num], part[:condition]] }
      sales_opportunities = []
      parts.each do |part|
        #stick auction in sales opportunities if the auction is not the user's, already contains a user bid, or if the auction isn't asking for the part in questions condition
        Auction.where(part_num: part.part_num, active: true).each do |auction|
          insider_user = auction.company == user
          user_placed_bids = (auction.bids & user.bids).present?
          part_matches = auction.condition.include?(part.condition)
          sales_opportunities << auction unless insider_user || user_placed_bids || !part_matches
          sales_opportunities << auction if auction.condition == "All Conditions" && auction.company != user && !user_placed_bids
        end
      end
      # require 'pry'
      # binding.pry
      sales_opportunities.uniq
    end

    # def self.get_sales_opportunities(user)
    #   parts = user.inventory_parts
    #   sales_opportunities = []
    #   parts.each do |inventory|
    #     self.where(part_num: inventory.part_num, active: true).each do |auction|
    #       p auction
    #       p sales_opportunities << auction if auction.company != user && auction.condition.include?(inventory.condition)
    #     end
    #   end
    #   sales_opportunities.uniq!
    # end
end
