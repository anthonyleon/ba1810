class Aircraft < ActiveRecord::Base
  belongs_to :company
  has_many :documents, dependent: :destroy

  enum service_status: [:off_service, :in_service]
end
