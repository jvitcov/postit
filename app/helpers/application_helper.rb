module ApplicationHelper
	def fix_url(str)
		str.starts_with?('http://') ? str : "http://#{str}"
	end

	def fix_date(dt)
		dt.strftime("%l:%M on %A, %B %-d, %Y")
	end
end
