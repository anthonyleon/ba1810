class Auction < ActiveRecord::Base
  delegate :company, :to => :user, :allow_nil => true
  belongs_to :user
  belongs_to :project
  has_one :tx, class_name: "Transaction"#, foreign_key: "tx_id"
  has_one :auction_part, dependent: :destroy
  has_one :part, through: :auction_part
  belongs_to :destination
  has_many :bids, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :bidders, through: :bids, source: :company
  has_many :invites, dependent: :destroy

  validates :quantity, presence: true
  validates :part_num, presence: true


  before_save :strip_whitespace
  before_save :upcase_part_num

  serialize :condition, Array # rename auctions.condition to auctions.condition
  serialize :req_forms, Array
  # serialize :invitees, Array

  accepts_nested_attributes_for :tx


  def self.conditions
    %w(recent overhaul serviceable as_removed non_serviceable scrap)
  end

  def conditions # patch until column is renamed
    condition.to_a
  end

  def self.forms
    %w(FAA EASA JAA CAAC SEGVOO TC)
    
  end


  def self.active
    where(active: true)
  end

  def self.companies_w_auctions
    Company.joins(:auctions).where(auctions: {active: true}).select("DISTINCT companies.*")
  end

  def resale_check
    if resale_status == "Yes"
      resale_yes = true
      resale_no = false
    else
      resale_no = true
      resale_yes = false
    end
  end

  def upcase_part_num
    part_num.upcase!
  end

  def strip_whitespace
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end


  def any_condition?
    conditions[0].blank?
  end

  def set_invitees(invited)
    hashy = Hash.new
    invited.each_slice(2) do |a, b|
      hashy.merge!({a.split.map(&:capitalize).join(' ') => b.downcase})
    end
    hashy
    invite_and_setup_suppliers(hashy)
  end

  def invite_and_setup_suppliers(invitees)
    invitees.each do |k, v|
      secret = SecureRandom.urlsafe_base64
      v.downcase!
      co = Company.find_by(email: v) || Company.find_by(name: k)
      if co
        co.update_attribute('confirm_token', secret) if co.confirm_token == nil
        CompanyMailer.invite_existing_user_to_bid(co, v, self).deliver_later(wait_until: 10.seconds.from_now)
      else
        co = Company.create(name: k, email: v.downcase.squish, email_confirmed: true, temp: true, password: secret) #user will come and create a password
        CompanyMailer.invite_temp_user_to_bid(v, self).deliver_later(wait_until: 1.minute.from_now)
      end
      Invite.create(auction: self, company: co)
      Notification.notify(user, :invite, auction: self)
    end
  end

  def self.check_new_inventory_for_auction_matches
    where(matched: false).each do |auc|
      part_matches = InventoryPart.where(part_num: auc.part_num).where.not(company: auc.company)

      if !part_matches.empty?
        part_matches.each do |part|
          @its_a_match = (auc.conditions.include?(part.condition.to_sym) || auc.any_condition?) ? true : false
          break if @its_a_match
        end
      end
      auc.update_attribute('matched', true) if @its_a_match
    end
  end


  #this should be deleted
  def self.part_match_or_not_actions(auction, part_match)
    #part_match is for Parts Table
    if part_match
      AdminMailer.new_auction(auction).deliver_later(wait_until: 1.minute.from_now)
      AuctionPart.make(part_match, auction)
    end

  #if the part for the RFQ doesn't match a part in our parts_db
    if !part_match
      AdminMailer.no_part_match(auction).deliver_later(wait_until: 1.minute.from_now)
      AuctionPart.temporary_make(auction)
    end

  # For InventoryPart check if auction matches one DOESN"T TAKE INTO ACCOUNT WHEN NEW INVENTORY IS UPLOADED
  ##  This is only for system_admin to check what auctions are matching
    part_match = InventoryPart.where(part_num: auction.part_num)
    not_owned = (part_match.size == 1 && part_match[0].company != auction.company)
    if part_match && not_owned
      auction.update_attribute('matched', true)
    else
      auction.update_attribute('matched', false)
    end
  end

  # this should be deleted
  def self.define_matched_auctions(auction)
        part = InventoryPart.where.not(company: auction.company).where(part_num: auction.part_num)
      if !part.empty?
        auction.update_attribute('matched', true)
      else
        auction.update_attribute('matched', false)
      end
  end

  def full_address
    "#{destination.address}, #{destination.city.capitalize}, #{destination.state.upcase} #{destination.zip} #{destination.country.upcase}"
  end

  def semi_address
    "#{destination.city.capitalize}, #{destination.state.upcase} #{destination.zip} #{destination.country.upcase}"
  end
end
