class CsvImport
	require "benchmark"
	require 'csv'

	def self.csv_import(file, company)


## SECOND GO AT ACTIVE RECORD IMPORT
				# CSV.parse(body, col_sep: "|", headers:true) do |row|
				# 	row_hash = row.to_hash
				# 	binding.pry
				# 	part = InventoryPart.new(
				# 		part_num: row[:part_num], 
				# 		description: row[:description], 
				# 		condition: row[:condition].
				# 		part_id: row[part_id
				# 		)
				# 	inv_parts << part
					
				# end
				# InventoryPart.import inv_parts


#FIRST GO AT ACTIVE RECORD IMPORT
				# p imported_parts = CSV.read("#{Rails.root}/tmp/faster_csv_import.csv")
				# counter = 0
				# stuff = []
				# imported_parts.each do |p|
				# 	self.match_condition(p)

				# 	part_num = p[0]
				# 	quantity = p[1].to_i
				# 	desc = p[2]
				# 	cond = p[3]


				# 	part_match = Part.find_by(part_num: part_num)
				# 	p[2] = part_match.description if part_match
	   #      part_match = build_new_part(part_num, desc) if !part_match
	   #      part_id = part_match.id

	   #      p[1] = part_id.to_i

    #     	quantity.times do
    #     		stuff << p
    #     	end

	   #    end



    # 		columns = [:part_num, :part_id, :description, :condition]
 			# 	tmp = stuff
 			# 	binding.pry
    # 		InventoryPart.import columns, tmp, :validate => false
			
		time = Benchmark.measure do
			InventoryPart.transaction do
				inv_parts = []
				CSV.foreach(file) do |p|
					
					p[3] = self.match_condition(p)

					part_num = p[0]
					quantity = p[1].to_i
					desc = p[2]
					cond = p[3]
					serial_num = p[4]
					part_hash = {part_num: part_num, description: desc}

					#check if part exists in database.. If not create it and flag it.
					@part_match = Part.find_by(part_num: part_num)
	        @part_match = build_new_part(part_hash[:part_num], part_hash[:description]) if !@part_match

	        #create quantity number of inventory parts
					quantity.times do 
						inv_part = InventoryPart.new(
							part_num: part_num, 
							description: desc, 
							condition: cond, 
							part_id: @part_match.id, 
							serial_num: serial_num
							)
						build_inv_part(@part_match, inv_part, company)
					end
				end	
			end
		end

	end

  def self.match_condition(part)
    case part[3].squish.upcase
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

  def self.build_inv_part part_match, inventory_part, company
    inventory_part.description = part_match[:description]
    inventory_part.manufacturer.upcase! if inventory_part.manufacturer
    inventory_part.company = company
    inventory_part.part = part_match
    inventory_part.part_num.upcase!
    inventory_part.save!
  end

end