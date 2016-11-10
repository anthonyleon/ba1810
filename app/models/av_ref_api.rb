class AvRefApi
	# The general format of the request url is: http://www.avrefweb.com/Service/<License Key>/<Request Type>/<Search Value>
	# example call http://avrefweb.com/Service/e85c0e58fb89427cb47948cba2945a7d/partnum/A07D32


	def self.part_num_check(part_number)
		request_type = 'partnum'
		search_value = part_number
		if part = Part.find_by(part_num: part_number.upcase)
			return part_match_found = { part_num: part.part_num, description: part.description, 
				manufacturer: part.manufacturer, manufacturer_price: part.manufacturer_price }
		else
			response = HTTParty.get("http://www.avrefweb.com/Service/#{ENV['AV_REF_KEY']}/#{request_type}/#{search_value}")
			# I don't know if this is the best check
			## bad response response.empty? == true
			## good response response.empty? == false
			part_match_found = !response.empty?		
			if part_match_found 
				response[0]["MfgPrice"].slice!("$")
				p response
				p "*****" * 80

				part_match_found = {part_num: response[0]["PartNum"], description: response[0]["Description"], 
					manufacturer: response[0]["Manufacturer"], manufacturer_price: response[0]["MfgPrice"].to_d }

			#log part in data base if it's not there
				Part.create(	            
					part_num: 					part_match_found[:part_num],
		            manufacturer_price: 		part_match_found[:manufacturer_price],
		            description: 				part_match_found[:description],
		            manufacturer: 				part_match_found[:manufacturer]
		        )
			end	
		end
	end


	def self.check_for_alternates(part_number)
		request_type = 'alternates'
		search_value = part_number
		response = HTTParty.get("http://www.avrefweb.com/Service/#{ENV['AV_REF_KEY']}/#{request_type}/#{search_value}")
	end

end