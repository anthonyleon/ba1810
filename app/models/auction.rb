class Auction < ActiveRecord::Base
  belongs_to :company
  belongs_to :project
  has_one :tx, class_name: "Transaction"#, foreign_key: "transaction_id"
  has_one :auction_part, dependent: :destroy
  has_one :part, through: :auction_part
  has_one :destination
  has_many :bids, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :bidders, through: :bids, source: :company

  validates :quantity, presence: true
  validates :part_num, presence: true


  before_save :strip_whitespace
  before_save :upcase_part_num

  serialize :condition, Array # rename auctions.condition to auctions.condition
  serialize :req_forms, Array
  # serialize :invitees, Array

  accepts_nested_attributes_for :tx


  def self.conditions
    %w(recent overhaul as_removed serviceable non_serviceable scrap)
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
      hashy.merge!({a.downcase => b.downcase})
    end
    self.invitees = hashy
  end

  def invite_and_setup_suppliers
    invitees.each do |k, v|
      # Once I've addeed multiple logins for a company (i.e. roles) then I have to change this conditional
      ## to be if Company.find_by(name: k) || User.find_by(email: v)
      v.downcase!
      co = Company.find_by(email: v)
      if co
        CompanyMailer.invite_existing_user_to_bid(v, self).deliver_later(wait_until: 1.minute.from_now)
      else
        secret = SecureRandom.urlsafe_base64
        co = Company.create(name: k.split.map(&:capitalize).join(' '), email: v.downcase.squish, email_confirmed: true, temp: true, password: secret) #user will come and create a password
        CompanyMailer.invite_temp_user_to_bid(v, self).deliver_later(wait_until: 1.minute.from_now)
      end
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

  def self.define_matched_auctions(auction)
        part = InventoryPart.where.not(company: auction.company).where(part_num: auction.part_num)
      if !part.empty?
        auction.update_attribute('matched', true)
      else
        auction.update_attribute('matched', false)
      end
  end

  def full_address
    "#{destination_address}, #{destination_city.capitalize}, #{destination_state.upcase} #{destination_zip} #{destination_country.upcase}"
  end

  def semi_address
    "#{destination_city.capitalize}, #{destination_state.upcase} #{destination_zip} #{destination_country.upcase}"
  end

end
