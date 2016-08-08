class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :inventory_parts, dependent: :destroy
  has_many :aircrafts
  has_many :engines
  has_many :ratings, dependent: :destroy
  has_many :transactions
  has_many :notifications, dependent: :destroy
  has_many :documents, dependent: :destroy
  validates :password, presence: true, length: { minimum: 6 }
  validates :password, :format => {with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/ ,message: "Password must be 8 characters long.  Must contain letters and numbers." }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  # validates :EIN, uniqueness: true
  # validates :address, :city, :state, :zip, :country, presence: true
  # validates :phone, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format, please input correct form: xxx-xxx-xxxx" }

  before_create :confirmation_token
  before_save :downcase_email

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

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    CompanyMailer.password_reset(self).deliver_now
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
