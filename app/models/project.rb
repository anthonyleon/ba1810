class Project < ActiveRecord::Base

	belongs_to :destination
	belongs_to :user
	has_many :auctions, dependent: :destroy
	has_many :bids, through: :auctions
	attr_accessor :street_addy, :city, :state, :zip, :country
	validates :reference_num, presence: true

end
