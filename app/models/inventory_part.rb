class InventoryPart < ActiveRecord::Base
  belongs_to :company
  belongs_to :part
  has_many :bids
  has_many :documents, dependent: :destroy
end
