class Counter
	attr_reader :birth_order
	
	def self.counted_new
		@count = 0 if @count.nil?
		@count += 1
		new
	end
	
	def self.count
		@count or 0
	end
	
	def self.reset
		@count = 0
	end
end
