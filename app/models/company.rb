class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions, dependent: :destroy
  # has_many :bids, dependent: :destroy
  has_many :bids, through: :inventory_parts
  has_many :inventory_parts, dependent: :destroy
  has_many :aircrafts
  has_many :engines
  has_many :ratings, dependent: :destroy
  has_many :transactions
  has_many :notifications, dependent: :destroy
  has_many :documents
  has_many :company_docs
  validates :password, presence: true, length: { minimum: 6 }
  # validates :password, :format => {with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/ ,message: "Password must be 8 characters long.  Must contain letters and numbers." }
  # validates :email, presence: true, uniqueness: true
  # validates :name, presence: true, uniqueness: true
  # validates :ein, uniqueness: true
  # validates :address, :city, :state, :zip, :country, presence: true

  before_create :confirmation_token
  before_save :downcase_email, :strip_whitespace

  before_validation(:on => :create) do
    self.inc_state = self.state
    self.inc_country = self.country
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
    # only for testing in development seeds
    unless self.armor_user_id
      armor_ids = ArmorPaymentsApi.create_account(self)
      self.update_attribute('armor_account_id', armor_ids[:armor_account_number])
      self.update_attribute('armor_user_id', armor_ids[:armor_user_number])
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Company.exists?(column => self[column])
  end

  def self.company_types
    {"Public Corporation (Co/Corp)" => 1, "Private Corporation" => 2, "Sole Proprietorship" => 3, "Limited Liability Company (LLC)" => 4,
      "Limited Liability Partnership (LLP)" => 5, "Limited Company (Ltd)" => 6, "Incorporation (Inc)" => 7 }
  end

  def auctions_with_owned_bids
    auctions = []
    self.bids.each do |bid|
      auctions << bid.auction if bid.auction.active
    end
    auctions.uniq { |auction| [auction[:id]] }
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    CompanyMailer.password_reset(self).deliver_now
  end

  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end

  def sales_opportunities
    sales_opportunities = []
    user_bids = bids

    inventory_parts.
      includes(part: :auctions).
      joins(part: {auctions: [:company]}).
      joins("LEFT OUTER JOIN bids ON bids.auction_id = auctions.id").
      joins("LEFT OUTER JOIN inventory_parts inventory_company_parts ON bids.inventory_part_id = inventory_company_parts.id").
      joins("LEFT OUTER JOIN companies companies_bids ON inventory_company_parts.company_id = companies_bids.id").
      where.not("auctions.company" => self). # user didn't create the auction
      where("companies_bids.id IS NULL or companies_bids.id != ? ", id). # user didn't make a bid
      distinct.
      each do |inventory_part|
        inventory_part.auctions.includes(:bids).each do |auction|
          conditions = auction.conditions
          part_matches = conditions.include?(inventory_part.condition.to_sym)
          user_has_placed_bids = (auction.bids & user_bids).present?
          any_condition = conditions[0].blank?

          if (part_matches || any_condition) && !user_has_placed_bids
            sales_opportunities << auction
          end
        end
      end
    sales_opportunities.uniq
  end

  def self.spit
    Company.all.each do |co|
      puts co.id.to_s + "\t -- \t" + co.name
    end
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
