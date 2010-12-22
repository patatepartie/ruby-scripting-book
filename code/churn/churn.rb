require 'subversion-repository'

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
  repository = SubversionRepository.new
  start_date = repository.svn_date(month_before(Time.now))

  puts header(start_date)
  lines = subsystem_names.collect do |name|
    puts subsystem_line(name, repository.change_count_for(name, start_date))
  end

  puts order_by_descending_change_count(lines)
end
