#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---
def month_before(a_time)
  a_time - 28 * 24 * 60 * 60
end

def svn_date(a_time)
  a_time.strftime("%Y-%m-%d")
end

def header(svn_start_date, svn_end_date)
  "Changes between #{svn_start_date} and #{svn_end_date}:"
end

def subsystem_line(subsystem_name, change_count)
  asterisks = asterisks_for(change_count)
  changes = changes_for(change_count)
  "#{subsystem_name.ljust(14)} #{changes.ljust(14)} #{asterisks}"
end

def changes_for(change_count)
  if change_count == 0
    "-"
  else
    "(#{change_count} changes)"
  end
end

def asterisks_for(an_integer)
  if an_integer == 0
    '-'
  elsif an_integer <= 2
    '*'
  else
    '*' * (an_integer / 5.0).round
  end
end

def change_count_for(name, start_date)
  extract_change_count_from(svn_log(name, start_date))
end


def extract_change_count_from(log_text)
  lines = log_text.split("\n")
  dashed_lines = lines.find_all do | line |
    line.include?('--------') 
  end
  count = dashed_lines.length - 1
  if count < 0
    message = "Subversion returned no log. Is the network down?"
    raise Exception.new(message)
  end
  count
end

def svn_log(subsystem, start_date)
  timespan = "--revision 'HEAD:{#{start_date}}'"
  root = "svn://rubyforge.org//var/svn/churn-demo"
    
  `svn log #{timespan} #{root}/#{subsystem}`
end


if $0 == __FILE__
  subsystem_names = ['audit', 'fulfillment', 'persistence',
                     'ui', 'util', 'inventory']
  start_date = svn_date(month_before(Time.now))
  end_date = svn(Time.now)

  puts header(start_date, end_date)
  subsystem_names.each do | name |
    puts subsystem_line(name, change_count_for(name, start_date)) 
  end
end
