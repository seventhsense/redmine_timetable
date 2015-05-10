require File.expand_path('../../test_helper', __FILE__)

class TteventsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

  def test_issue_lists
    skip
    get 'issue_lists'
    assert_response :success
  end
end
