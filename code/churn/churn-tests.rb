#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---
require 'test/unit'   #(1)
require 'churn'           #(2)

class  ChurnTests < Test::Unit::TestCase #(3)

  def test_month_before_is_28_days  #(4)
    assert_equal(Time.local(2005, 1, 1), 
		 month_before(Time.local(2005, 1, 29)))  #(5)
  end

  def test_header_format
    assert_equal("Changes since 2005-08-05:", header(Time.local(2005, 8, 5)))
  end

  def test_header_format
    assert_equal("Changes since 2005-08-05:", header(month_before(Time.local(2005, 9, 2))))
  end

  def test_normal_subsystem_line_format
    assert_equal('         audit ********* (45)', 
                 subsystem_line("audit", 45))
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
    assert_equal(2, extract_change_count_from("------------------------------------------------------------------------\nr2 | marick | 2005-08-07 14:26:21 -0500 (Mon, 07 Aug 2005) | 1 linei\n\nadded code to handle merger\n------------------------------------------------------------------------\nr1 | marick | 2005-08-07 14:21:47 -0500 (Mon, 07 Aug 2005) | 1 line\n\nfirst touches\nNo commit for revision 0.\n------------------------------------------------------------------------\n"))
  end
end
