class Part < ActiveRecord::Base
  has_many :inventory_parts
  has_many :auction_parts
  has_many :auctions, through: :auction_parts

end
