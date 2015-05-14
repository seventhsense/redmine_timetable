require File.expand_path('../../test_helper', __FILE__)

class TteventTest < ActiveSupport::TestCase
  fixtures :projects, :issues, :users
  # fixtures :ttevents
  # def setup
    # puts 'before'
  # end
  # def teardown
    # puts 'after'
  # end

  # def after_tests
    # puts 'after tests'
  # end
  # def test_load_fixture
    # @project = projects(:projects_001)
    # # assert_same 1, @project.id
    # assert { @project.id == 1 }
  # end

  def test_issue_has_many_ttevents
    assert_association Issue, :has_many, :ttevents
    assert_association Ttevent, :belongs_to, :issue
  end

  def test_save
    set_one_ttevent_sample
    assert { @ttevent.is_done == false }
  end

  def test_default_is_done_is_false
    set_one_ttevent_sample
    is_done = Ttevent.find(@ttevent.id).is_done
    assert { is_done == false }
  end

  def test_duration
    set_one_ttevent_sample
    assert { @ttevent.duration == 0.5 }
  end

  def test_default_color
    # due_date is nil
    set_one_ttevent_sample(:issues_002)
    p @ttevent.start_time
    assert { @ttevent.color == "#da3aad" }
    # due_date is 10 days after
    set_one_ttevent_sample
    assert { @ttevent.color == "#3aad87"}
    # due_date is 5 days ago
    set_one_ttevent_sample(:issues_003)
    assert { @ttevent.color == '#da3a3a' }
    # due_date is 1 day after
    set_one_ttevent_sample(:issues_006)
    assert { @ttevent.color == '#da873a' }
  end

  private
  def set_one_ttevent_sample(issue_no= :issues_001)
    @user = users(:users_002)   
    @issue = issues(issue_no)
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    @ttevent = Ttevent.new(
      user_id: @user.id,
      issue_id: @issue.id,
      start_time: start_time,
      end_time: end_time
    )
    @ttevent.save
  end
end
