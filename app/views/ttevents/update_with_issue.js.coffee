$('#dialog').dialog('close')
$('#modal_area').html('')
id = "<%= @ttevent.id %>"
title = "<%= @ttevent.issue.project.name%> - <%= @ttevent.issue.subject %>"
start = "<%= @ttevent.start_time.iso8601 %>"
end = "<%= @ttevent.end_time.iso8601 %>"
color = "<%= @ttevent.color %>"
duration = "<%= @ttevent.duration %>"
event = window_event
event.id = id
event.title = title
event.start = start
event.end = end
event.color = color
event.duration = duration
$('#fullcalendar').fullCalendar('updateEvent', event)
# $('#fullcalendar').fullCalendar('refetchEvents')
delete window_event
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
<% if @error != true %>
  text = "<%= l(:success_update_issue_and_ttevent)%>"
  type = 'success'
<% else %>
  text = "<%= l(:error_something_went_wrong)%>"
  type = 'error'
<% end %> 

noty
  text: text
  layout: 'center'
  type: type
  timeout: 800
