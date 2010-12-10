def month_before(a_time)
  a_time - 28 * 24 * 60 * 60
end

if $0 == __FILE__
  subsystem_names = ['audit', 'fulfilment', 'persistence', 'ui', 'util', 'inventory']
  start_date = month_before(Time.now)

  puts header(start_date)
  subsystem_names.each do |name|
    puts subsystem_line(name, change_count_for(name))
  end
end
