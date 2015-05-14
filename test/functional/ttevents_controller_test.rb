require File.expand_path('../../test_helper', __FILE__)

class TteventsControllerTest < ActionController::TestCase
  fixtures :users, :issues
  plugin_fixtures :ttevents
  def setup
    @request.session[:user_id] = 2
    Setting.default_language = 'ja'
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_issue_lists
    xhr :get, :issue_lists
    assert_response :success
  end

  def test_new_issue
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    # @current_user = users(:users_001)
    xhr :get, :new_issue,
      ttevent: {start_time: start_time, end_time: end_time}
    assert_response :success
  end
end
