class InventoryPart < ActiveRecord::Base
  # validates :serial_num, presence: true
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
      row.delete(nil)
      if row["part_num"] != nil #account for empty lines in spreadsheet
        quantity = row["quantity"].to_i
        part = find_by_id(row["id"]) || new
        row = self.match_condition(row)
        
        row.delete("quantity")
        part.attributes = row.to_hash.slice(*row.to_hash.keys)
        @part_match = Part.find_by(part_num: part.part_num)
        if !@part_match 
          @part_match = build_new_part(part)
          # array[1] = part.part_num #invalid part number
          # return array
        end
        quantity.times do
          inv_part = InventoryPart.new(part.attributes)
          build_inv_part(@part_match, inv_part, company)
        end
      end
    end
    return array
  end


  def self.match_condition(part)
    case part["condition"].squish.upcase
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
    when "NE" || "NEW" 
      part["condition"] = 0
    when "NS" || "NEW SURPLUS" 
      part["condition"] = 0
    when "FN" || "FACTORY NEW"
      part["condition"] = 0
    end
    part
  end

##for an imported file
  def self.build_inv_part part_match, inventory_part, company
    inventory_part.description = part_match[:description]
    inventory_part.manufacturer.upcase! if inventory_part.manufacturer
    inventory_part.company = company
    inventory_part.part = part_match
    inventory_part.part_num.upcase!
    inventory_part.save!
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
  def strip_whitespace
    self.attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?("squish")
    end
  end
# end import file methods

#==============================================================  

#for an individually uploaded part
  def add_part_details part_match, user
    self.description = part_match[:description]
    self.part = part_match
    self.part_num.upcase!
    self.company = user
  end

  def self.build_new_part(part)
    new_part = Part.create(part_num: part.part_num, description: part.description, flagged: true, manufacturer: "")
  end




end
