class AvRefApi
	# The general format of the request url is: http://www.avrefweb.com/Service/<License Key>/<Request Type>/<Search Value>
	# example call http://avrefweb.com/Service/e85c0e58fb89427cb47948cba2945a7d/partnum/A07D32

	def part_num_check(part_num)
		request_type = 'partnum'
		search_value = part_num
		p response = HTTParty.get("http://www.avrefweb.com/Service/#{ENV['AV_REF_KEY']}/#{request_type}/#{search_value}")
	end

end