module ApplicationHelper
	def fix_url(str)
		str.starts_with?('http://') ? str : "http://#{str}"
	end

	def fix_date(dt)
		dt.localtime.strftime("%l:%M%P %Z on %A, %B %-d, %Y")
	end
end
