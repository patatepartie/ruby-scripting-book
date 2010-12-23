require 'test/unit'
require 'counter'

class CounterTests < Test::Unit::TestCase
	def setup
		Counter.reset
	end

	def test_counts_new_instances
		assert_equal(0, Counter.count)
		Counter.counted_new
		assert_equal(1, Counter.count)
		Counter.counted_new
		assert_equal(2, Counter.count)
	end
	
	def test_birth_order
		first = Counter.counted_new
		second = Counter.counted_new
		assert_equal(2, second.birth_order)
		assert_equal(1, first.birth_order)
	end
end
