def month_before(a_time)
  a_time - 28 * 24 * 60 * 60
end

def header(an_svn_date)
  "Changes since #{an_svn_date}:"
end

def subsystem_line(subsystem_name, change_count)
  asterisks = asterisks_for(change_count)
  "#{subsystem_name.rjust(14)} #{asterisks} (#{change_count.inspect})"
end

def asterisks_for(an_integer)
  '*' * (an_integer / 5.0).round
end

def extract_change_count_from(log_text)
  lines = log_text.split("\n")
  dashed_lines = lines.find_all do | line |
    line.include?('------')
  end
  dashed_lines.length - 1
end

def svn_log(subsystem, start_date)
  timespan = "--revision 'HEAD:{#{start_date}}'"
  root = "svn://rubyforge.org//var/svn/churn-demo"

  `svn log #{timespan} #{root}/#{subsystem}`
end

def change_count_for(name, start_date)
  extract_change_count_from(svn_log(name, start_date))
end

def svn_date(a_time)
  a_time.strftime("%Y-%m-%d")
end

def order_by_descending_change_count(lines)
  lines.sort do |one, another|
    one_count = churn_line_to_int(one)
    another_count = churn_line_to_int(another)

    - (one_count <=> another_count)
  end
end

def churn_line_to_int(line)
  /\((\d+)\)/.match(line)[1].to_i
end

if $0 == __FILE__
  subsystem_names = ['audit', 'fulfilment', 'persistence', 'ui', 'util', 'inventory']
  start_date = svn_date(month_before(Time.now))

  puts header(start_date)
  lines = subsystem_names.collect do |name|
    puts subsystem_line(name, change_count_for(name, start_date))
  end

  puts order_by_descending_change_count(lines)
end
