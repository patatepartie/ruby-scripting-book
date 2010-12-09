unless ARGV.length == 2
  puts "Usage: differences.rb old-inventory new-inventory"
  exit
end

def boring?(line)
  line.split('/').include?('temp') or line.split('/').include?('recycler')
end

def inventory_from(filename)
  inventory = File.open(filename)
  downcased = inventory.collect do |line|
    line.chomp.downcase
  end
  downcased.reject do |line|
    boring?(line)
  end
end

old_inventory = inventory_from(ARGV[0])
new_inventory = inventory_from(ARGV[1])

puts "The following files have been added:"
puts new_inventory - old_inventory

puts ""
puts "The following files have been deleted:"
puts old_inventory - new_inventory
