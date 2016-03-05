class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions, dependent: :destroy 
  has_many :bids
  has_many :inventory_parts
  validates :password, presence: true, length: { minimum: 8 }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
