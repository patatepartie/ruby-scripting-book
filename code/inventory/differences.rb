unless ARGV.length == 2
  puts "Usage: differences.rb old-inventory new-inventory"
  exit
end

old_inventory = File.open(ARGV[0]).readlines
new_inventory = File.open(ARGV[1]).readlines

puts "The following files have been added:"
puts new_inventory - old_inventory

puts ""
puts "The following files have been deleted:"
puts old_inventory - new_inventory
