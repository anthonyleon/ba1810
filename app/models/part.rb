class Part < ActiveRecord::Base
  has_many :inventory_parts
  has_many :auction_parts
end
