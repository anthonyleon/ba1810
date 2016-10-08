class Engine < ActiveRecord::Base
  belongs_to :company
  has_many :documents, dependent: :destroy

  enum condition: [:recent, :overhaul, :as_removed, :serviceable, :non_serviceable, :scrap]
  enum service_status: [:off_service, :in_service]
end
