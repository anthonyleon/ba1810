class Bid < ActiveRecord::Base
  # belongs_to :company # TODO: remove bids.company_id
  has_one :company, through: :inventory_part
  belongs_to :auction
  belongs_to :inventory_part
  has_one :tx, class_name: "Transaction", dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :inventory_part, presence: true
  validates :part_price, presence: true
  validates :est_shipping_cost, presence: true
  # before_save :strip_symbols
  # before_create :strip_symbols
  before_save :strip_whitespace

  
  def seller
    company
  end

  def buyer
    auction.company
  end

  def average_rating
    arr = []
    company.ratings.each do |rating|
      arr << rating.timeliness
      arr << rating.documentation
      arr << rating.packaging
      arr << rating.dependability
    end
    arr.compact!
    (arr.sum / arr.count.to_f) unless arr.empty?
  end

  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end
  private

  # def strip_symbols
  #   self.part_price.gsub!(/[ $,]/, '').to_d
  #   self.est_shipping_cost.gsub(/[ $,]/, '')
  # end
end
