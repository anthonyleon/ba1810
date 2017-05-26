class Destination < ActiveRecord::Base
	has_many :auctions, dependent: :destroy
end
