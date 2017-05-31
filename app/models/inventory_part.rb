class InventoryPart < ActiveRecord::Base
  # validates :serial_num, presence: true
  validates :part_num, presence: true
  validates :condition, presence: true
  belongs_to :company
  belongs_to :part
  has_many :auctions, through: :part
  has_many :bids, dependent: :destroy
  has_many :documents, dependent: :destroy

  before_save :strip_whitespace
  enum condition: [:recent, :overhaul, :as_removed, :serviceable, :non_serviceable, :scrap]

  @@condition_abbreviations = {
    "overhaul" => "OH",
    "recent" => "NE",
    "serviceable" => "SV",
    "as_removed" => "AR",
    "scrap" => "SC",
    "non_serviceable" => "NSV"
  }

  def abbreviated_condition
    @@condition_abbreviations[condition]
  end

  def self.conditions
    %w(recent overhaul as_removed serviceable non_serviceable scrap)
  end
  
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
