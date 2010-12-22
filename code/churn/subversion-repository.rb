class SubversionRepository

	def date(a_time)
		a_time.strftime("%Y-%m-%d")
	end

	def change_count_for(name, start_date)
		extract_change_count_from(svn_log(name, start_date))
	end
	
	def extract_change_count_from(log_text)
		lines = log_text.split("\n")
		dashed_lines = lines.find_all do | line |
		  line.include?('------')
		end
		dashed_lines.length - 1
	end

	def log(subsystem, start_date)
		timespan = "--revision 'HEAD:{#{start_date}}'"
		root = "svn://rubyforge.org//var/svn/churn-demo"

		`svn log #{timespan} #{root}/#{subsystem}`
	end
end
