require 'benchmark'
require 'csv'

class CsvImport

	def self.jsonize_csv(file)
		json = CSV.read(file.path).to_json
		nj = JSON.parse(json)
	end

	def self.import_inventory(data, company)
		time = Benchmark.measure do
			headers = data.lazy.first
			data.lazy.first.delete(headers)
			data.lazy.each_slice(75) do |lines|
				Part.transaction do 
					parts_array = lines.map do |line|
						line.each { |l| l.scrub! }
						Hash[headers.zip(line)]
					end

					inventory = []
					parts_array.map do |row|
						part_match = Part.find_by(part_num: row['part_num'])
						new_part = build_new_part(row['part_num'], (row['description'] || "")) unless part_match
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
					
					InventoryPart.import inventory

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
						row["condition"] = match_condition(row)
						auction = Auction.new(
							company: Company.find(company_id),
							part_num: row["part number"],
							condition: [row["condition"]],

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
			return 1
		when "OVERHAUL" 
			return 1
		when "RD"
			return 1
		when "AR" 
			return 2
		when "AS REMOVED"
			return 2
		when "SV"
			return 3
		when "SERVICEABLE"
			return 3
		when "RP"
			return 4
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

	## commented out on 4/20/17 because I don't believe we need this anymore
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