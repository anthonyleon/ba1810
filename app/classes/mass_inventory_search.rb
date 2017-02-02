

	# File.open("TurboPartsRev.txt", 'w') { |file| 
	# 	File.readlines("TurboParts.txt").each do |line|
	# 		file.write(line.gsub(/\n/, ','))
	# 	end
	# }

File.readlines("TurboParts.txt").each do |line|
	part = line.gsub(/\n/, '')
	quantity = InventoryPart.where(part_num: part).count
	p part if quantity > 0
end