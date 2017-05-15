require 'benchmark'
require 'csv'

class CsvImport

	def self.jsonize_csv(file)
		json = CSV.read(file.path, :quote_char => "\'").to_json # needs to be json = CSV.read(file.path, :encoding => 'ISO-8859-1').to_json
		nj = JSON.parse(json)				## but this is exceeding the redis memory allocation
	end

	def self.import_inventory(data, company)
		time = Benchmark.measure do
			headers = data.lazy.first
			data.delete(headers)
			data.lazy.each_slice(75) do |lines|
				Part.transaction do 
					parts_array = lines.map do |line|
						# line.each { |l| l.scrub! }
						Hash[headers.zip(line)]
					end


					inventory = []
					parts_array.map do |row|
						binding.pry if row[headers[0]] == nil
						part_match = Part.find_by(part_num: row[headers[0]])
						new_part = build_new_part(row[headers[0]], (row['description'] || "")) unless part_match
						quantity = row['quantity'].to_i
						row.delete('quantity')
						row["condition"] = match_condition(row)
						quantity.times do 
							part = InventoryPart.new(
								part_num: row["part_num"], 
								description: row["description"], 
								condition: row["condition"],
								serial_num: row["serial_num"],
								company: company,
								part_id: part_match ? part_match.id : new_part.id
								)
							inventory << part			
						end
					end

					inventory.each_slice(100) do |i|
						InventoryPart.import i
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
								part_num: _row[headers[0]],
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

	def self.mass_rfq(data, company_id, project_id, address)
		headers = data.first
		data.delete(headers)
		project = Project.find(project_id)
		data.lazy.each_slice(75) do |lines|
			Auction.transaction do 
				part_requests = lines.map do |line|
					if line[0] != nil && line[1] != nil
						line.each { |l| l.scrub!.gsub!(/\s+/, "") unless l == nil}
						Hash[headers.zip(line)]
					end
				end
				rfqs = []
				auction_parts = []
				parts = []

				part_requests.map do |row|
					unless row == nil
						
						part_match = Part.find_by(part_num: row['part number']) || build_new_part(row['part number'], (row['description'] || ""))
						parts << part_match
						row["condition"] = match_auction_condition(row)
						auction = Auction.new(
							company: Company.find(company_id),
							part_num: row["part number"],
							condition: row["condition"],

							destination_address: address["street_addy"],
							destination_zip: address["zip"],
							destination_city: address["city"],
							destination_country: address["country"],
							destination_state: address["state"],
							cycles: row["cycles"],
							quantity: row["quantity"],
							target_price: row["target price"],
							# req_forms: [],
							# invitees: {},
							project: project
							)

						rfqs << auction
						
					end
				end

				Auction.import rfqs
				AuctionPart.transaction do
					count = 0
					rfqs.each do |auction|
						auction_part = AuctionPart.new( part_num: auction.part_num, description: parts[count].description,
							manufacturer: parts[count].manufacturer, auction: auction, part: parts[count])
						auction.auction_part = auction_part
						auction_parts << auction_part
					end
					AuctionPart.import auction_parts
				end
			end
			

		end		

	end

	#Match part condition with enum
	def self.match_condition(part)

		case part["condition"].squish.upcase
		when "OH"
			return :overhaul
		when "OVERHAUL" 
			return :overhaul
		when "RD"
			return :overhaul
		when "AR" 
			return :as_removed
		when "AS REMOVED"
			return :as_removed
		when "SV"
			return :serviceable
		when "SERVICEABLE"
			return :serviceable
		when "RP"
			return :non_serviceable
		when "SC"
			return :non_serviceable
		when "SCRAP"
			return :non_serviceable
		when "NSV"
			return :scrap
		when "NON SERVICEABLE"
			return :scrap
		when "NE"
			return :recent
		when "NEW" 
			return :recent
		when "NS"
			return :recent
		when "NEW SURPLUS" 
			return :recent
		when "FN"
			return :recent
		when "FACTORY NEW"
			return :recent
		end
	end

	def self.build_new_part(part_number, desc)

		Part.create(part_num: part_number, description: desc, flagged: true, manufacturer: "")
	end

	def self.match_auction_condition(part)
		conditions = []

		case part["condition"].squish.upcase
		when "OH"
			conditions << :overhaul
		when "OVERHAUL" 
			conditions << :overhaul
		when "RD"
			conditions << :overhaul
		when "AR" 
			conditions << :as_removed
		when "AS REMOVED"
			conditions << :as_removed
		when "SV"
			conditions << :serviceable
		when "SERVICEABLE"
			conditions << :serviceable
		when "RP"
			conditions << :non_serviceable
		when "SC"
			conditions << :non_serviceable
		when "SCRAP"
			conditions << :non_serviceable
		when "NSV"
			conditions << :scrap
		when "NON SERVICEABLE"
			conditions << :scrap
		when "NE"
			conditions << :recent
		when "NEW" 
			conditions << :recent
		when "NS"
			conditions << :recent
		when "NEW SURPLUS" 
			conditions << :recent
		when "FN"
			conditions << :recent
		when "FACTORY NEW"
			conditions << :recent
		end
		conditions << [:""]
	end

end

	## commented out on 4/:as_removed0/17 because I don't believe we need this anymore
	# def self.csv_import(whole_file, company)
	# 	time = Benchmark.measure do
	# 		File.open(whole_file.path) do |file|
	# 			headers = file.first
	# 			file.lazy.each_slice(75) do |lines|
	# 				Part.transaction do 
	# 					inventory = []
	# 					insert_to_parts_db = []
	# 					rows = CSV.parse(lines.join.scrub, write_headers: true, headers: headers)
	# 					rows.map do |row|
	# 						part_match = Part.find_by(part_num: row['part_num'])
	# 						new_part = build_new_part(row['part_num'], (row['description'] || "")) unless part_match
	# 						quantity = row['quantity'].to_i
	# 						row.delete('quantity')
	# 						row["condition"] = match_condition(row)

	# 						quantity.times do 
	# 							part = InventoryPart.new(
	# 								part_num: row["part_num"], 
	# 								description: row["description"], 
	# 								condition: row["condition"],
	# 								serial_num: row["serial_num"],
	# 								company_id: company.id,
	# 								part_id: part_match ? part_match.id : new_part.id
	# 								)			
	# 							inventory << part					
	# 						end
	# 					end
	# 					InventoryPart.import inventory
	# 				end
	# 			end
	# 		end			
	# 	end
	# 	puts time
	# end