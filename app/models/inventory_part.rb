class InventoryPart < ActiveRecord::Base
  validates :serial_num, presence: true
  validates :part_num, presence: true
  validates :condition, presence: true
  belongs_to :company
  belongs_to :part
  has_one :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :bids
  has_many :documents, dependent: :destroy
  before_save :condition_format


# until I can fix the radio button to accept the abbreviations (testing purposes)
  def condition_format
    case self.condition
    when "overhaul"
      self.condition = "OH"
    when "as_removed"
      self.condition = "AR"
    when "serviceable"
      self.condition = "SV"
    when "scrap"
      self.condition = "SC"
    when "new"
      self.condition = "NE"
    end
  end

  # class methods for importing xls, csv files using Roo
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
