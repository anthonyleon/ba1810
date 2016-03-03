class Bid < ActiveRecord::Base
  belongs_to :company
  belongs_to :auction
  belongs_to :inventory_part
end
