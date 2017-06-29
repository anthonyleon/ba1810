class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bids, through: :inventory_parts
  has_many :auctions, dependent: :destroy
  has_many :inventory_parts, through: :company
  has_many :notifications, dependent: :destroy
  has_many :projects
  has_many :invites, dependent: :destroy
  belongs_to :company

  def name
  	first_name + " " + last_name
  end

  def auctions_with_owned_bids
    auctions = []
    self.bids.each do |bid|
      auctions << bid.auction if bid.auction.active
    end
    auctions.uniq { |auction| [auction[:id]] }
  end
  
end
