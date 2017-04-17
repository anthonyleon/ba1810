class Project < ActiveRecord::Base
	belongs_to :company
	has_many :auctions
	has_many :bids, through: :auctions

end
