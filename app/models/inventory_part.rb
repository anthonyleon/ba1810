class InventoryPart < ActiveRecord::Base
  validates :serial_num, presence: true
  validates :part_num, presence: true
  validates :condition, presence: true
  belongs_to :company
  belongs_to :part
  has_many :bids
  has_many :documents, dependent: :destroy


  # self methods for importing xls, csv files using Roo
  def self.import(file, current_user)
	  spreadsheet = open_spreadsheet(file)
  	  header = spreadsheet.row(1)
  	  (2..spreadsheet.last_row).each do |i|
  	  	row = Hash[[header, spreadsheet.row(i)].transpose]
  	  	part = find_by_id(row["id"]) || new
  	  	part.attributes = row.to_hash.slice(*row.to_hash.keys)
      part.company = current_user
    	part.save!

      end
  end

  def self.get_file_type(file)
    File.extname(file.original_filename).gsub('.','')
  end

  def self.open_spreadsheet(file)
    extension = get_file_type(file)
    if extension.in?(%w(csv xls xlsx))
      Roo::Spreadsheet.open(file.path, extension: extension)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end
end
