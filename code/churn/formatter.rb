class Formatter
	def initialize
		@subsystem_changes = []
	end
	
	def report_range(start_date, end_date)
		@start_date = start_date
		@end_date = end_date
	end

	def use_subsystem_with_change_count(subsystem_name, change_count)
		@subsystem_changes << [subsystem_name, change_count]
	end
	
	def output
	 	lines = @subsystem_changes.collect do | subsystem_change |
		  subsystem_line(subsystem_change[0], subsystem_change[1]) 
		end
		[header] + order_by_descending_change_count(lines).collect do | line |
			line
		end
	end
	
	def header
		"Changes since #{date(@start_date)}:"
	end
	
  def date(a_time)
    a_time.strftime("%Y-%m-%d")
  end
	
	def subsystem_line(subsystem_name, change_count)
		asterisks = asterisks_for(change_count)
		"#{subsystem_name.rjust(14)} #{asterisks} (#{change_count})"
	end

	def asterisks_for(an_integer)
		'*' * (an_integer / 5.0).round
	end
	
	def order_by_descending_change_count(lines)
		lines.sort do | one, another |
		  one_count = churn_line_to_int(one)
		  another_count = churn_line_to_int(another)
		  - (one_count <=> another_count)
		end
	end

	def churn_line_to_int(line)
		/\((\d+)\)/.match(line)[1].to_i
	end
end
