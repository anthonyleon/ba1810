class CompanyDoc < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	has_many :documents, dependent: :destroy
	belongs_to :company
end
