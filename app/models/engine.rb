class Engine < ActiveRecord::Base
  belongs_to :company
  has_many :documents, dependent: :destroy

  validates :engine_major_variant, presence: true
  validates :engine_minor_variant, presence: true
  validates :esn, presence: true
  validates :condition, presence: true
  validates :location, presence: true
  validates :cycles_remaining, presence: true
  validates :available_date, presence: true
  validates :service_status, presence: true

  accepts_nested_attributes_for :documents

  enum condition: [:recent, :overhaul, :as_removed, :serviceable, :non_serviceable, :scrap]
  enum service_status: [:off_service, :in_service]
end
