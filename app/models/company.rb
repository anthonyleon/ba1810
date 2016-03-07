class Company < ActiveRecord::Base
  has_secure_password
  has_many :auctions, dependent: :destroy 
  has_many :bids
  has_many :inventory_parts
  validates :password, presence: true, length: { minimum: 8 }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  before_create :confirmation_token

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  private
  
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
