class CsvImport
	require "benchmark"
	require 'csv'
	def self.import(company)
		time = Benchmark.measure do
			InventoryPart.transaction do
				CSV.foreach("#{Rails.root}/tmp/faster_csv_import.csv") do |p|
					self.match_condition(p)
					
					part_num = p[0]
					quantity = p[1].to_i
					desc = p[2]
					cond = p[3]
					part_hash = {part_num: part_num, description: desc}
					
					puts part_hash
					#check if part exists in database.. If not create it and flag it.
					@part_match = Part.find_by(part_num: part_num)
	        @part_match = build_new_part(part_hash) if !@part_match

	        #create quantity number of inventory parts
					quantity.times do 
						inv_part = InventoryPart.new(part_num: part_num, description: desc, condition: cond)
						build_inv_part(@part_match, inv_part, company)
					end
				end
			end
		end
		puts time
	end

  def self.match_condition(part)
    case part[3].squish.upcase

    when "OH" || "OVERHAUL"
      part[3] = 1
    when "AR" || "AS REMOVED"
      part[3] = 2
    when "SV" || "SERVICEABLE"
      part[3] = 3
    when "SC" || "SCRAP"
      part[3] = 4
    when "NSV" || "NON SERVICEABLE"
      part[3] = 5
    when "NE" || "NEW" 
      part[3] = 0
    when "NS" || "NEW SURPLUS" 
      part[3] = 0
    when "FN" || "FACTORY NEW"
      part[3] = 0
    end
    part
  end

  def self.build_new_part(part)
    new_part = Part.create(part_num: part.part_num, description: part.description, flagged: true, manufacturer: "")
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