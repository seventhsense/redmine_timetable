Redmine::Plugin.register :redmine_timetable do
  name 'Redmine Timetable plugin'
  author 'Seventh'
  description 'Timetable using fullcalendar'
  version '0.2.2'
  url 'https://github.com/seventhsense/redmine_timetable'
  author_url 'http://blog.scimpr.com'

  require_dependency 'time_entry_patch'

  menu :top_menu, :redmine_timetable, {
    controller: 'ttevents', action: 'index'
  }, caption: :timetable

  permission :view_timetable, ttevents: :index
  permission :edit_timetable, ttevents: :edit
end
