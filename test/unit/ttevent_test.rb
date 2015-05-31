require File.expand_path('../../test_helper', __FILE__)
# UnitTest for Ttevent
class TteventTest < ActiveSupport::TestCase
  fixtures :projects, :issues, :users
  # fixtures :ttevents

  def test_issue_has_many_ttevents
    assert_association Issue, :has_many, :ttevents
    assert_association Ttevent, :belongs_to, :issue
  end

  def test_save
    create_one_ttevent_sample
    assert { @ttevent.is_done == false }
  end

  def test_default_is_done_is_false
    create_one_ttevent_sample
    is_done = Ttevent.find(@ttevent.id).is_done
    assert { is_done == false }
  end

  def test_duration
    create_one_ttevent_sample
    assert { @ttevent.duration == 0.5 }
  end

  test 'test_default_color' do
    # due_date is nil
    create_one_ttevent_sample(:issues_002)
    assert { @ttevent.color == '#da3aad' }
    # due_date is 10 days after
    create_one_ttevent_sample
    assert { @ttevent.color == '#3aad87' }
    # due_date is 5 days ago
    create_one_ttevent_sample(:issues_003)
    assert { @ttevent.color == '#da3a3a' }
    # due_date is 1 day after
    create_one_ttevent_sample(:issues_006)
    assert { @ttevent.color == '#da873a' }
  end

  private

  def create_one_ttevent_sample(issue_no = :issues_001)
    @user = users(:users_002)
    @issue = issues(issue_no)
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    @ttevent = Ttevent.create(
      user_id: @user.id,
      issue_id: @issue.id,
      start_time: start_time,
      end_time: end_time
    )
  end
end
