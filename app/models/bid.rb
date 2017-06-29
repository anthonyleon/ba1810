class Bid < ActiveRecord::Base
  has_one :company, through: :inventory_part
  belongs_to :auction
  belongs_to :inventory_part
  has_one :tx, class_name: "Transaction", dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :documents, dependent: :destroy

  # validates :inventory_part, presence: true
  validates :part_price, presence: true
  validates :est_shipping_cost, presence: true
  # before_save :strip_symbols
  # before_create :strip_symbols
  before_save :strip_whitespace

  
  def seller
    user
  end

  def buyer
    auction.user
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

  def self.matched_parts(auction, user)
    match_parts = []
    parts = user.inventory_parts
    parts.where(part_num: auction.part_num).each do |part|
      match_parts << part if auction.condition.include?(part.condition.to_sym) || auction.condition[0].blank?
    end
  end

  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end

  def self.strip_symbols(params)
    params[:part_price].gsub!(/[ $,]/, '').to_d if !params[:part_price].empty?
    params[:est_shipping_cost].gsub!(/[ $,]/, '').to_d if !params[:est_shipping_cost].empty?
  end


end
