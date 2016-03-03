class InventoryPart < ActiveRecord::Base
  belongs_to :company
  belongs_to :part
  has_many :bids
end
