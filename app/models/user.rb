class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bids, through: :inventory_parts
  has_many :notifications, dependent: :destroy
  has_many :projects
  has_many :invites, dependent: :destroy
  belongs_to :company
end
