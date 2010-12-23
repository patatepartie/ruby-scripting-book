require 'test/unit'
require 'counter'

class CounterTests < Test::Unit::TestCase
	def test_counts_new_instances
		assert_equal(0, Counter.count)
		Counter.counted_new
		assert_equal(1, Counter.count)
		Counter.counted_new
		assert_equal(2, Counter.count)
	end
end
