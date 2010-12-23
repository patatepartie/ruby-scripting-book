#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---

class SubversionRepository

  def initialize(root)
    @root = root    # (1)
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
	def use_date(a_date)
		@start_date = a_date
	end
	
	def output
		[header(@start_date)]
	end
	
	def header(a_date)
		"Changes since #{a_date}:"
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
  start_date = repository.date(month_before(Time.now))

	formatter = Formatter.new
	formatter.use_date(start_date)
  puts formatter.output
  
  lines = subsystem_names.collect do | name |
    formatter.subsystem_line(name, repository.change_count_for(name, start_date)) 
  end
  puts formatter.order_by_descending_change_count(lines)
end

