def month_before(a_time)
  a_time - 28 * 24 * 60 * 60
end

def header(a_time)
  a_time.strftime("Changes since %Y-%m-%d:")
end

def subsystem_line(subsystem_name, change_count)
  asterisks = asterisks_for(change_count)
  "#{subsystem_name.rjust(14)} #{asterisks} (#{change_count.inspect})"
end

def asterisks_for(an_integer)
  '*' * (an_integer / 5.0).round
end

if $0 == __FILE__
  subsystem_names = ['audit', 'fulfilment', 'persistence', 'ui', 'util', 'inventory']
  start_date = month_before(Time.now)

  puts header(start_date)
  subsystem_names.each do |name|
    puts subsystem_line(name, change_count_for(name))
  end
end
