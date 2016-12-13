class InventoryPart < ActiveRecord::Base
  # validates :serial_num, presence: true
  validates :part_num, presence: true
  validates :condition, presence: true
  belongs_to :company
  belongs_to :part
  has_one :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :bids, dependent: :destroy
  has_many :documents, dependent: :destroy

  before_save :strip_whitespace
  enum condition: [:recent, :overhaul, :as_removed, :serviceable, :non_serviceable, :scrap]

  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end
# end import file methods

#==============================================================  

#for an individually uploaded part
  def add_part_details part_match, user
    self.description = part_match[:description]
    self.part = part_match
    self.part_num.upcase!
    self.company = user
  end

end
