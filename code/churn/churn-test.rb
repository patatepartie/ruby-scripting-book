require 'test/unit'
require 'churn'

class ChurnTests < Test::Unit::TestCase
  def test_month_before_is_28_days
    assert_equal(Time.local(2005, 1, 1), month_before(Time.local(2005, 1, 29)))
  end
end
