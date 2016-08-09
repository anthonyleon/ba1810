class Document < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
  validates :name, presence: true # Make sure the owner's name is present.
  belongs_to :inventory_part
  belongs_to :company
  belongs_to :aircraft
  belongs_to :engine
  belongs_to :company_doc
end
