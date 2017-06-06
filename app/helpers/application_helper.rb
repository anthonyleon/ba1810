module ApplicationHelper
  def redirect_back
    redirect_to :back
  end

	def to_pretty_time(time)
		a = (Time.now-time).to_i
		case a
			when 0..82800 
				'Today' 
			when 82801..172000 
				'A Day Ago' # 86400 = 1 Day
			when 172001..518400 
				((a+800)/(60*60*24)).to_i.to_s+' Days Ago'
			when 518400..1036800 
				'A Week Ago'
			else 
				((a+180000)/(60*60*24*7)).to_i.to_s+' Weeks Ago'
		end
	end

	def override_default(attribute)
		if attribute == "N/A"
			nil
		else
			attribute
		end
	end
end
