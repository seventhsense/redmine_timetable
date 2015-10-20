require File.expand_path('../../test_helper', __FILE__)

# testing time table statistics
class TtstatisticsControllerTest < ActionController::TestCase
  # base test
  class BaseTest < ActionController::TestCase
    fixtures :projects, :versions, :users, :email_addresses, :roles, :members,
             :member_roles, :issues, :journals, :journal_details,
             :trackers, :projects_trackers, :issue_statuses,
             :enabled_modules, :enumerations, :boards, :messages,
             :attachments, :custom_fields, :custom_values, :time_entries,
             :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions
    def setup
      Role.find(1).add_permission! :manage_own_timetable
      @request.session[:user_id] = 2
      Setting.default_language = 'ja'
    end
  end

  # test for index action
  class IndexTest < BaseTest
    def test_index
      # t_count = Ttevent.all.count
      # assert { t_count == 6 }
      # setup_ttevents
      # t_count = Ttevent.all.count
      # assert { t_count == 415 }
      # get :index
      # assert_response :success
      # assert { assigns(:current_user) == users(:users_002) }
      # # binding.pry
      # assert { assigns(:issues_assigned_count) == 1 }
      # assert { assigns(:ttevents_average) == 5.0 }
      # assert { assigns(:ttevents_max) == 5 }
      # today = Date.today.strftime('%Y年 %m月 %d日')
      # assert { assigns(:ttevents_max_date) == today }
      # assert { assigns(:ttevents_hour_average) == 5.0 }
      # assert { assigns(:ttevents_hour_max) == 5.0 }
      # # p assigns(:ttevents_hour_date)
      # assert { assigns(:ttevents_undone) == 0 }
      # assert { assigns(:ttevents_undone_hour) == 0 }
      # assert { assigns(:project_membered_count) == 6 }
      # assert { assigns(:new_issues_assigned_last_month_count) == 1 }
      # assert { assigns(:end_issues_assigned_last_month_count) == 0 }
      # assert { assigns(:new_issues_assigned_this_month_count) == 0 }
      # assert { assigns(:end_issues_assigned_this_month_count) == 0 }
    end

    private

    def setup_ttevents
      Ttevent.all.destroy_all
      today = Date.today
      # 2 month ago
      today.ago(2.months).to_date.all_month.each do |day|
        setup_fullday_ttevents(day)
      end
      # 1 month ago
      today.ago(1.month).to_date.all_month.each do |day|
        setup_fullday_ttevents(day)
      end
      # this month
      (today.beginning_of_month..today).each do |day|
        setup_fullday_ttevents(day)
      end
    end

    def setup_fullday_ttevents(date)
      (1..5).each do |count|
        start_time = Time.local(date.year, date.month, date.day, count * 2 + 6)
        end_time = start_time.since(1.hour)
        ttevent = Ttevent.new(
          start_time: start_time,
          end_time: end_time,
          user_id: 2,
          issue_id: 4,
          is_done: true
        )
        ttevent.build_time_entry(
          issue_id: ttevent.issue.id,
          hours: 1.0,
          activity_id: 9,
          spent_on: start_time
        )
        ttevent.time_entry.user_id = 2
        ttevent.save!
      end
    end
  end

  # test for stats action
  class StatsPageTest < BaseTest
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
end
