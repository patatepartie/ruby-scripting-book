require 'test/unit'
require 'churn'

class ChurnTests < Test::Unit::TestCase
  def test_month_before_is_28_days
    assert_equal(Time.local(2005, 1, 1), month_before(Time.local(2005, 1, 29)))
  end

  def test_header_format
    assert_equal("Changes since 2005-08-05:", header(month_before(Time.local(2005, 9, 2))))
  end

  def test_normal_subsystem_line_format
    assert_equal('         audit ********* (45)', subsystem_line("audit", 45))
  end

  def test_asterisks_for_divides_by_five
    assert_equal('****', asterisks_for(20))
  end

  def test_asterisks_for_rounds_up_and_down
    assert_equal('****', asterisks_for(18))
    assert_equal('***', asterisks_for(17))
  end

  def test_subversion_log_can_have_no_changes
    assert_equal(0, extract_change_count_from("------------------------------------------------------------------------\n"))
  end

  def test_subversion_log_with_changes
    assert_equal(2, extract_change_count_from("------------------------------------------------------------------------\n\
      r2 | marick | 2005-08-07 14:26:21 -0500 (Mon, 07 Aug 2005) | 1 line\n\n\
      added code to handle merger\n\
      ------------------------------------------------------------------------\n\
      r1 | marick | 2005-08-07 14:21:47 -0500 (Mon, 07 Aug 2005) | 1 line\n\n\
      first touches\n\
      ------------------------------------------------------------------------\n"))
    end
end
