require File.expand_path('../../test_helper', __FILE__)

class TteventsControllerTest < ActionController::TestCase
  fixtures :users
  def test_index
    get :index
    assert_response :success
  end

  def test_issue_lists
    skip
    get 'issue_lists'
    assert_response :success
  end

  def test_new_issue
    skip
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    @current_user = users(:users_001)
    get :new_issue, ttevent: {start_time: start_time, end_time: end_time}
    assert_response :success
  end
end
