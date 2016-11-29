class Part < ActiveRecord::Base
  has_many :inventory_parts
  has_many :auction_parts

  # class methods for importing xls, csv files using Roo
  def self.import(file)
    array = []
    counter = 0
    spreadsheet = open_spreadsheet(file)
    # header = spreadsheet.row(1)
 	header = ["part_num", "manufacturer", "description", "model", "cage_code", "nsn"]
    (2..spreadsheet.last_row).each do |i|
      	row = Hash[[header, spreadsheet.row(i)].transpose]
	    part = find_by_id(row["id"]) || new

	    part.attributes = row.to_hash.slice(*row.to_hash.keys)
	    build_part(part) unless Part.find_by(part_num: part.part_num)
    end
  end
  

#for an imported file
  def self.build_part part
    part.description = part[:description]
    part.manufacturer.upcase!
    part.part_num.upcase!
    part.save!
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
