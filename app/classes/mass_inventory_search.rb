class MassInventorySearch

	require 'csv'
	# File.open("TurboPartsRev.txt", 'w') { |file| 
	# 	File.readlines("TurboParts.txt").each do |line|
	# 		file.write(line.gsub(/\n/, ','))
	# 	end
	# }
	def self.check_database(file_name)
		parts = []
		puts "*" * 800
		all_parts = InventoryPart.all
		puts all_parts.count

		File.readlines(file_name)[10..41].each do |line|
			part = line.gsub(/\t/, '')
			parts << part #if all_parts.find_by(part_num: part)
		end
		File.open("JW Partss.txt", 'w') {|file|
			file.write("Total Parts Count: " + parts.count.to_s + " \n \n")
			parts.each do |x|
				file.write(x + "\n")
			end
		}
	end

	def self.who_has(file_name)
		parts = []
		puts "*" * 800
		all_parts = InventoryPart.where.not(company_id: 17)
		puts all_parts.count

		File.readlines(file_name).each do |line|
			part = line.gsub(/\n/, '')
			inv_parts = all_parts.where(part_num: part).uniq { |p| p.company.id }
			parts << inv_parts unless inv_parts.empty?
		end
		parts.flatten!
		count_array = []
		parts.each do |part|
			part_count = 0
			parts.each do |ip|
				part_count += 1 if(ip.part_num == part.part_num && part.company == ip.company)
			end
			count_array << part_count
		end
		count_and_inventory = parts.zip(count_array)
		consolidated_inventory = count_and_inventory.uniq { |s| 
			[ s[0].part_num, s[0].company.id, s[1] ] }

		CSV.open("part_data.csv", "wb") do |csv|
			consolidated_inventory.each do |p|
				csv << [ p.first.part_num, p.first.company.name, p.second ]
			end
		end
		# File.open("Parts By Company.txt", 'w') {|file|
		# 	file.write("Total Parts Count: " + parts.count.to_s + " \n \n")
		# 	parts.each do |x|
		# 		file.write(x + "\n")
		# 	end
		# }
	end

	def self.line_counter(file_name)
		File.readlines(file_name).count
	end
end