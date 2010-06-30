require 'test/unit'
require 'churn-classes'

class  SubversionRepositoryTests < Test::Unit::TestCase
	def setup
		@repository = SubversionRepository.new("svn://rubyforge.org//var/svn/churn-demo")
	end
	
	def test_date
    assert_equal("2005-08-05", @repository.date(Time.local(2005, 8, 5)))
  end

	def test_subversion_log_can_have_no_changes
    assert_equal(0, @repository.extract_change_count_from("------------------------------------------------------------------------\n"))
  end

  def test_subversion_log_with_changes
    assert_equal(2, @repository.extract_change_count_from("------------------------------------------------------------------------\nr2 | marick | 2005-08-07 14:26:21 -0500 (Mon, 07 Aug 2005) | 1 linei\n\nadded code to handle merger\n------------------------------------------------------------------------\nr1 | marick | 2005-08-07 14:21:47 -0500 (Mon, 07 Aug 2005) | 1 line\n\nfirst touches\nNo commit for revision 0.\n------------------------------------------------------------------------\n"))
  end
end
