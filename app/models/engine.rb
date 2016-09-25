class Engine < ActiveRecord::Base
  belongs_to :company
  has_many :documents, dependent: :destroy

  enum condition: [:recent, :overhaul, :serviceable, :non_serviceable]
end
