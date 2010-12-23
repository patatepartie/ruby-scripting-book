class Counter
	def self.counted_new
		@count = 0 if @count.nil?
		@count += 1
		new
	end
	
	def self.count
		@count
	end
end
