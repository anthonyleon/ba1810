class MassInventorySearch

	# File.open("TurboPartsRev.txt", 'w') { |file| 
	# 	File.readlines("TurboParts.txt").each do |line|
	# 		file.write(line.gsub(/\n/, ','))
	# 	end
	# }
	def self.check_database(file_name)
		parts = []
		puts "*" * 800
		all_parts = InventoryPart.where.not(company_id: 17)
		puts all_parts.count

		File.readlines(file_name).each do |line|
			part = line.gsub(/\n/, '')
			parts << part if all_parts.find_by(part_num: part)
		end
		File.open("Parts In Inventory.txt", 'w') {|file|
			file.write("Total Parts Count: " + parts.count.to_s + " \n \n")
			parts.each do |x|
				file.write(x + "\n")
			end
		}
	end

	def self.line_counter(file_name)
		File.readlines(file_name).count
	end
end