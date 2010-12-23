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
	
	def test_birth_order_nil_by_default
		assert_equal(nil, Counter.counted_new.birth_order)
	end
end
