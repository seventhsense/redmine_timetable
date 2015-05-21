require File.expand_path('../../test_helper', __FILE__)

class TteventsControllerTest < ActionController::TestCase
  plugin_fixtures :ttevents, :users
  fixtures :projects, :versions, :users, :email_addresses, :roles, :members,
           :member_roles, :issues, :journals, :journal_details,
           :trackers, :projects_trackers, :issue_statuses,
           :enabled_modules, :enumerations, :boards, :messages,
           :attachments, :custom_fields, :custom_values, :time_entries,
           :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions,
           :ttevents
  def setup
    @request.session[:user_id] = 2
    Setting.default_language = 'ja'
  end

  def test_ttevents_list
    start_time = Date.today
    end_time = Date.tomorrow
    xhr :get, :ttevents_list,
      timezone: 'Tokyo', start_time: start_time, end_time: end_time
    assert_response :success
  end

  def test_holiday_list
    start_time = Date.today
    end_time = Date.tomorrow
    xhr :get, :ttevents_list,
      timezone: 'Tokyo', start_time: start_time, end_time: end_time
    assert_response :success
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_get_ttevent
    ttevent = ttevents(:ttevents_001)
    xhr :get, :get_ttevent, id: ttevent.id
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

  def test_tracker_list
    project = projects(:projects_001)
    xhr :get, :tracker_list, id: project.id
    assert_response :success
  end

  def test_create_issue
    user = users(:users_002)
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    project = projects(:projects_001)
    params = { issue: {
      project_id: project.id,
      tracker_id: 1,
      subject: "some text",
      due_date: Date.today.to_s,
      author_id: user.id,
      assigned_to_id: user.id,
      priority_id: 3,
      ttevents_attributes: [{
        user_id: user.id,
        start_time: start_time.to_s,
        end_time: end_time.to_s
      }]
    }}
    xhr :post, :create_issue, params
    assert_response :success
  end

  def test_create
    user = users(:users_002)
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    issue = issues(:issues_001)
    params = {ttevent: {
      start_time: start_time,
      end_time: end_time,
      issue_id: issue.id
    }}
    xhr :post, :create, params
    assert_response :success
  end

  def test_edit
    ttevent = ttevents(:ttevents_001)
    xhr :get, :edit, id: ttevent.id
    assert_response :success
  end

  def test_update
    ttevent = ttevents(:ttevents_001)
    start_time = Time.now
    end_time = start_time.since(30.minutes)
    xhr :put, :update, id: ttevent.id, ttevent: {
      start_time: start_time,
      end_time: end_time,
    }
    assert_response :success
  end

  def test_update_with_issue
    ttevent = ttevents(:ttevents_001)
    xhr :put, :update_with_issue, id: ttevent.id, issue: {
      done_ratio: 40,
      status_id: 3,
      due_date: Date.today,
      ttevent: {
        is_done: true
      },
      time_entry: {
        spent_on: ttevent.start_time,
        hours: ttevent.duration,
        activity_id: 8
      }
    }
    assert_response :success
  end

  def test_destroy
    ttevent = ttevents(:ttevents_001)
    xhr :delete, :destroy, id: ttevent.id
    assert_response :success
  end
end
