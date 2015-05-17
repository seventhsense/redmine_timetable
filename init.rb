Redmine::Plugin.register :redmine_timetable do
  name 'Redmine Timetable plugin'
  author 'Seventh'
  description 'Timetable using fullcalendar'
  version '0.9.5'
  url 'https://github.com/seventhsense/redmine_timetable'
  author_url 'http://blog.scimpr.com'

  require_dependency 'time_entry_patch'
  require_dependency 'issue_patch'

  menu :top_menu, :redmine_timetable, {
    controller: 'ttevents', action: 'index'
  }, caption: :timetable, if: Proc.new { User.current.logged? }

  # permission :manage_own_timetable,{
    # ttevents: [:ttevents_list, :holiday_list, :index, :get_ttevent, :issue_lists, :new_issue, :tracker_list, :create_issue, :create, :edit, :update, :update_with_issue, :destroy, :set_timezone, :set_issue_lists, :ttevent_params, :issue_params, :time_entry_params],
    # ttstatistics: [:index]
  # }
end
