class Part < ActiveRecord::Base
  has_many :inventory_parts
  has_many :auction_parts
  has_many :auctions, through: :auction_parts
  before_save :capitalize_part_num

  def capitalize_part_num
  	part_num.upcase!
  end
end
