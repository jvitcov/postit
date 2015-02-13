module ApplicationHelper
	def fix_url(str)
		str.starts_with?('http://') ? str : "http://#{str}"
	end

	def fix_date(dt)
		if logged_in? && !current_user.time_zone.blank?
			dt = dt.in_time_zone(current_user.time_zone)
		end

		dt.strftime("%l:%M%P %Z on %A, %B %-d, %Y")
	end
end
