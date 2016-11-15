class InventoryPart < ActiveRecord::Base
  validates :serial_num, presence: true
  validates :part_num, presence: true
  validates :condition, presence: true
  belongs_to :company
  belongs_to :part
  has_one :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :bids, dependent: :destroy
  has_many :documents, dependent: :destroy

  before_save :strip_whitespace
  enum condition: [:recent, :overhaul, :as_removed, :serviceable, :non_serviceable, :scrap]

  # class methods for importing xls, csv files using Roo
  def self.import(file, company)
    array = []
    counter = 0
	  spreadsheet = open_spreadsheet(file)
  	  header = spreadsheet.row(1)
  	  (2..spreadsheet.last_row).each do |i|
  	  	row = Hash[[header, spreadsheet.row(i)].transpose]
  	  	part = find_by_id(row["id"]) || new
        row = self.match_condition(row)
  	  	part.attributes = row.to_hash.slice(*row.to_hash.keys)
        part.update(part.attributes)
        @part_match = AvRefApi.part_num_check(part.part_num)
        if @part_match 
          build_inv_part(@part_match, part)
          part.company = company
        	if company.inventory_parts.exists?(serial_num: part.attributes["serial_num"], part_num: part.attributes["part_num"])
            counter += 1
            array[0] = counter
          else
            part.save!
          end
        else
          array[1] = part.part_num
          return array
        end
      end
      return array
  end


  def self.match_condition(part)
    case part["condition"].squish.upcase
    when "NE" || "NEW"
      part["condition"] = 0
    when "OH" || "OVERHAUL"
      part["condition"] = 1
    when "AR" || "AS REMOVED"
      part["condition"] = 2
    when "SV" || "SERVICEABLE"
      part["condition"] = 3
    when "SC" || "SCRAP"
      part["condition"] = 4
    when "NSV" || "NON SERVICEABLE"
      part["condition"] = 5
    end
    part
  end

  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end
  
#for an individually uploaded part
  def add_part_details part_match, user
    part = Part.find_by(part_num: part_match[:part_num].upcase)

    self.description = part_match[:description]
    self.part = part
    self.part_num.upcase!
    self.company = user
  end

#for an imported file
  def self.build_inv_part part_match, inventory_part
    inventory_part.description = part_match[:description]
    inventory_part.manufacturer.upcase!
    inventory_part.part_num.upcase!
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
