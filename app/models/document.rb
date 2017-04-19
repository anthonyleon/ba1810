class Document < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
  validates :name, presence: true # Make sure the owner's name is present.
  validates :attachment, presence: true
  belongs_to :inventory_part
  belongs_to :company
  belongs_to :aircraft
  belongs_to :engine
  belongs_to :company_doc
  belongs_to :bid
	def self.check_object(bid, inventory_part, engine, aircraft, company_doc, attachment)

		if bid
		  bid.documents.build(name: attachment.original_filename, attachment: attachment)
		elsif inventory_part
		  inventory_part.documents.build(name: attachment.original_filename, attachment: attachment)
		elsif engine
		  engine.documents.build(name: attachment.original_filename, attachment: attachment)
		elsif aircraft
		  aircraft.documents.build(name: attachment.original_filename, attachment: attachment)
		elsif company_doc
		  company_doc.documents.build(name: attachment.original_filename, attachment: attachment)
		end
	end
end
