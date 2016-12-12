class CsvImport
	require "benchmark"
	require 'csv'

	def self.csv_import(file, company)


# SECOND GO AT ACTIVE RECORD IMPORT
		time = Benchmark.measure do
			inv_parts = []
			parts_db = []
			CSV.parse(File.read(file), headers: true) do |row|

				row_hash = row.to_hash
				row_hash["condition"] = match_condition(row_hash)
				quantity = row_hash["quantity"].to_i

				part_match = Part.find_by(part_num: row_hash["part_num"])
				new_part = build_new_part(row_hash["part_num"], row_hash["description"]) if !part_match
				quantity.times do 
					part = InventoryPart.new(
						part_num: row_hash["part_num"], 
						description: row_hash["description"], 
						condition: row_hash["condition"],
						serial_num: row_hash["serial_num"],
						company_id: company.id,
						part_id: part_match.id
						)
					inv_parts << part 
				end
					parts_db << new_part if new_part
					
			end

			InventoryPart.import inv_parts
			Part.import parts_db
		end
		puts time
	end

	# def self.import_parts_db(file)
	# 	time = Benchmark.measure do
	# 		Part.transaction do 
	# 			parts_db = []
	# 				CSV.parse(File.read(file), headers: true) do |row|
	# 					row_hash = row.to_hash
	# 					# part_already_in_db = Part.find_by(part_num: row_hash["part_num"], manufacturer: row_hash["manufacturer"])

	# 					# if !part_already_in_db
	# 						part = Part.new(
	# 							part_num: row_hash["part_num"], 
	# 							description: row_hash["description"], 
	# 							manufacturer: row_hash["manufacturer"],
	# 							model: row_hash["model"],
	# 							cage_code: row_hash["cage_code"],
	# 							nsn: row_hash["nsn"]
	# 							)
	# 						parts_db << part
	# 						p self.eof?
	# 					# end
	# 				end
	# 			Part.import parts_db
	# 		end
	# 	end
	# 	puts time
	# end
	
	def self.import_parts_db(filename)
	  time = Benchmark.measure do
	    File.open(filename) do |file|
	      headers = file.first
	      file.lazy.each_slice(2000) do |lines|
	        Part.transaction do
	          rows = CSV.parse(lines.join, write_headers: true, headers: headers)
	          parts_db = rows.map do |_row|
	            Part.new(
	              part_num: _row['part_num'],
	              description: _row['description'],
	              manufacturer: _row['manufacturer'],
	              model: _row['model'],
	              cage_code: _row['cage_code'],
	              nsn: _row['nsn']
	            )
	          end
	          Part.import parts_db
	        end
	      end
	    end
	    puts time
	  end
	end

	def self.match_condition(part)
		case part["condition"].squish.upcase
		when "OH"
		  return 1
		when "OVERHAUL" 
		  return 1
		when "AR" 
			return 2
		when "AS REMOVED"
		  return 2
		when "SV"
		  return 3
		when "SERVICEABLE"
			return 3
		when "SC"
			return 4
		when "SCRAP"
		  return 4
		when "NSV"
		  return 5
		when "NON SERVICEABLE"
		  return 5
		when "NE"
		  return 0
		when "NEW" 
		  return 0
		when "NS"
		  return 0
		when "NEW SURPLUS" 
		  return 0
		when "FN"
		  return 0
		when "FACTORY NEW"
		  return 0
		end
	end

  def self.build_new_part(part_number, desc)
    Part.new(part_num: part_number, description: desc, flagged: true, manufacturer: "")
  end

  def self.build_inv_part part_match, inventory_part, company
    inventory_part.description = part_match[:description]
    inventory_part.manufacturer.upcase! if inventory_part.manufacturer
    inventory_part.company = company
    inventory_part.part = part_match
    inventory_part.part_num.upcase!
    inventory_part.save!
  end

end