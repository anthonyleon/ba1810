class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions
  has_many :bids
  has_many :inventory_parts
end
