#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---

class SubversionRepository

  def initialize(root)
    @root = root    # (1)
  end

  def change_count_for(name, start_date)
    extract_change_count_from(log(name, date(start_date)))
  end

  def date(a_time)
    a_time.strftime("%Y-%m-%d")
  end

  def extract_change_count_from(log_text)
    lines = log_text.split("\n")
    dashed_lines = lines.find_all do | line |
      line.include?('--------') 
    end
    dashed_lines.length - 1     
  end

  def log(subsystem, start_date)
    timespan = "--revision 'HEAD:{#{start_date}}'"
    
    `svn log #{timespan} #{@root}/#{subsystem}`      # (2)
  end

end

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

def month_before(a_time)
  a_time - 28 * 24 * 60 * 60
end


if $0 == __FILE__
  subsystem_names = ['audit', 'fulfillment', 'persistence',
                     'ui', 'util', 'inventory']     
  root="svn://rubyforge.org//var/svn/churn-demo"
  repository = SubversionRepository.new(root)
  last_month = month_before(Time.now)

	formatter = Formatter.new
	formatter.report_range(last_month, Time.now)
  
  subsystem_names.collect do | name |
    formatter.use_subsystem_with_change_count(name, repository.change_count_for(name, last_month)) 
  end
  
  puts formatter.output
end

