require File.expand_path('../../test_helper', __FILE__)

class TtstatisticsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :issues, :roles, :members, :member_roles 
  plugin_fixtures :ttevents

  def setup
    Role.find(1).add_permission! :manage_own_timetable
    @request.session[:user_id] = 2 
    Setting.default_language = 'ja'
  end

  def test_index
    get :index
    assert_response :success
    assert {assigns(:current_user) == users(:users_002)}
    p assigns(:issues_assigned_count)
    assert {assigns(:ttevents_average) == 1.3}
    assert {assigns(:ttevents_max) == 2}
    p assigns(:ttevents_max_date)
    assert {assigns(:ttevents_hour_average) == 1.8}
    assert {assigns(:ttevents_hour_max) == 3.0}
    p assigns(:ttevents_hour_date)
    assert {assigns(:ttevents_undone) == 1}
    assert {assigns(:ttevents_undone_hour) == 0.5}
    assert {assigns(:project_membered_count) == 6}
    assert {assigns(:new_issues_assigned_last_month_count) == 0}
    assert {assigns(:end_issues_assigned_last_month_count) == 0}
    assert {assigns(:new_issues_assigned_this_month_count) == 1}
    assert {assigns(:end_issues_assigned_this_month_count) == 0}

    # binding.pry
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
