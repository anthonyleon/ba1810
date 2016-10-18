class InventoryPart < ActiveRecord::Base
  validates :serial_num, presence: true
  validates :part_num, presence: true
  validates :condition, presence: true
  belongs_to :company
  belongs_to :part
  has_one :tx, class_name: "Transaction", foreign_key: "transaction_id"
  has_many :bids, dependent: :destroy
  has_many :documents, dependent: :destroy

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
  	  	part.attributes = row.to_hash.slice(*row.to_hash.keys)
        part.update(part.attributes)
        @part_match = Part.find_by(part_num: part.part_num)
        if @part_match 
          build_inv_part(@part_match, part)
          part.company = company
        	if company.inventory_parts.exists?(serial_num: part.attributes["serial_num"])
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

  def self.build_inv_part part_match, inventory_part
    inventory_part.description = part_match.description
    inventory_part.manufacturer = part_match.manufacturer
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
