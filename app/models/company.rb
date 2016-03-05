class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions
  has_many :bids
  has_many :inventory_parts

  before_save :check_values

  def check_values
    raise
  end
end
