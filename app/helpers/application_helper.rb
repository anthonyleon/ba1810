module ApplicationHelper
  def redirect_back
    redirect_to :back
  end

	def to_pretty_time(time)
		a = (Time.now-time).to_i
		case a
			when 0 
				'Just Now'
			when 1 
				'A Second Ago'
			when 2..59 
				a.to_s+' Seconds Ago' 
			when 60..119 
				'A Minute Ago' #120 = 2 Minutes
			when 120..3540 
				(a/60).to_i.to_s+' Minutes Ago'
			when 3541..7100 
				'An Hour Ago' # 3600 = 1 Hour
			when 7101..82800 
				((a+99)/3600).to_i.to_s+' Hours Ago' 
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
end
