def check_usage
  unless ARGV.length == 2
    puts "Usage: differences.rb old-inventory new-inventory"
    exit
  end
end

def contains?(line, pattern)
  line.chomp.split('/').include?(pattern)
end

def boring?(line, boring_words)
  boring_words.any? do |word|
    contains?(line, word)
  end
end

def inventory_from(filename)
  inventory = File.open(filename)
  downcased = inventory.collect do |line|
    line.downcase
  end

  downcased.reject do |line|
    boring?(line, ['temp', 'recycler'])
  end
end

def compare_inventory_files(old_file, new_file)
  old_inventory = inventory_from(old_file)
  new_inventory = inventory_from(new_file)

  added_files_count = (new_inventory - old_inventory).length
  puts "The following "
  puts added_files_count
  puts "file(s) have been added:"

  puts new_inventory - old_inventory

  puts ""
  removed_files_count = (old_inventory - new_inventory).length
  puts "The following "
  puts removed_files_count
  puts "file(s) have been deleted:"
  puts old_inventory - new_inventory

  puts ""
  unchanged_files_count = (old_inventory - (old_inventory - new_inventory)).length
  puts "The following "
  puts unchanged_files_count
  puts "file(s) have not changed:"
  puts old_inventory - (old_inventory - new_inventory)
end

if $0 == __FILE__
  check_usage
  compare_inventory_files(ARGV[0], ARGV[1])
end
