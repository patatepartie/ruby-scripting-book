class SubversionRepository
	def initialize(root)
		@root = root
	end

	def date(a_time)
		a_time.strftime("%Y-%m-%d")
	end
	
	def change_count_for(name, start_date)
		extract_change_count_from(log(name, start_date))
	end

	def extract_change_count_from(log_text)
		lines = log_text.split("\n")
		dashed_lines = lines.find_all do | line |
		  line.include?('-----')
		end
		dashed_lines.length - 1 
	end

	def log(subsystem, start_date)
		timespan = "--revision 'HEAD:{#{start_date}}'"

		`svn log #{timespan} #{@root}/#{subsystem}`
	end
end
