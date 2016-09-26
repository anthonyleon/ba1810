class Auction < ActiveRecord::Base
  belongs_to :company
  belongs_to :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_many :bids, dependent: :destroy
 	has_many :notifications

  enum condition: [:recent, :overhaul, :as_removed, :serviceable, :non_serviceable, :scrap]

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
