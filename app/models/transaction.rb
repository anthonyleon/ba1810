class Transaction < ActiveRecord::Base
	has_one :auction
	has_one :bid
	has_one :inventory_part
	# confused about this association transaction has buyer and seller (testing purposes)
	has_many :companies

end
