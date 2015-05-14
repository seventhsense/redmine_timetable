require File.expand_path('../../test_helper', __FILE__)

class TtstatisticsControllerTest < ActionController::TestCase
  fixtures :users, :issues, :roles 
  plugin_fixtures :ttevents

  def setup
    Role.find(1).add_permission! :manage_own_timetable
    @request.session[:user_id] = 2 
    Setting.default_language = 'ja'
  end

  def test_index
    get :index
    p assigns(:current_user)
    p assigns(:issues_assigned_count)
    assert_response :success
  end

  def test_stats_by_month
    get :stats_by_month
    assert_response :success
  end

  def test_stats_by_day
    get :stats_by_day
    assert_response :success
  end

  def test_daily_report
    get :daily_report
    assert_response :success
  end
end
