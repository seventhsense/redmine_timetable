require File.expand_path('../../test_helper', __FILE__)

class TteventTest < ActiveSupport::TestCase
  fixtures :projects
  # def setup
    # puts 'before'
  # end
  # def teardown
    # puts 'after'
  # end

  # def after_tests
    # puts 'after tests'
  # end
  def test_load_fixture
    @project = projects(:projects_001)
    # assert_same 1, @project.id
    assert { @project.id == 1 }
  end

  def test_issue_has_many_ttevents
    assert_association Issue, :has_many, :ttevents
    assert_association Ttevent, :belongs_to, :issue
  end
end
