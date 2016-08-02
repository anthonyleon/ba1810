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
