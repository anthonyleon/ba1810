class Destination < ActiveRecord::Base
	has_many :auctions
	has_many :projects
	
end
