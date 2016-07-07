class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions, dependent: :destroy
  has_many :bids
  has_many :inventory_parts
  has_many :ratings
  validates :password, presence: true, length: { minimum: 8 }
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
