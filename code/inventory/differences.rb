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

added_files_count = (new_inventory - old_inventory).length
puts "The following "
puts added_files_count
puts " files have been added:"

puts new_inventory - old_inventory

puts ""
removed_files_count = (old_inventory - new_inventory).length
puts "The following "
puts removed_files_count
puts " files have been deleted:"
puts old_inventory - new_inventory

puts ""
unchanged_files_count = (old_inventory - (old_inventory - new_inventory)).length
puts "The following "
puts unchanged_files_count
puts " files have not changed:"
puts old_inventory - (old_inventory - new_inventory)
