require "benchmark"
require 'csv'

class CsvImport

	def self.csv_import(filename, company)
		time = Benchmark.measure do
			File.open(filename) do |file|
				headers = file.first
				file.lazy.each_slice(150) do |lines|
					Part.transaction do 
						inventory = []
						insert_to_parts_db = []
						rows = CSV.parse(lines.join, write_headers: true, headers: headers)
						rows.map do |row|
							part_match = Part.find_by(part_num: row['part_num'])
							new_part = build_new_part(row['part_num'], row['description']) unless part_match
							quantity = row['quantity'].to_i
							row.delete('quantity')
							row["condition"] = match_condition(row)
							quantity.times do 
								part = InventoryPart.new(
									part_num: row["part_num"], 
									description: row["description"], 
									condition: row["condition"],
									serial_num: row["serial_num"],
									company_id: company.id,
									part_id: part_match ? part_match.id : new_part.id
									)			
								inventory << part					
							end
						end
						InventoryPart.import inventory
					end
				end
			end			
		end
		puts time
	end
	
	## part upload but no validations
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

	#Match part condition with enum
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
		Part.create(part_num: part_number, description: desc, flagged: true, manufacturer: "")
	end

end