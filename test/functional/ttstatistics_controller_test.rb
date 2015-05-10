require File.expand_path('../../test_helper', __FILE__)

class TtstatisticsControllerTest < ActionController::TestCase
  def test_index
    get :index
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
