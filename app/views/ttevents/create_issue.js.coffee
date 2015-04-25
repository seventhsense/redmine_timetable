$('#dialog').dialog('close')
$('#modal_area').html('')
id = "<%= @ttevent.id %>"
title = "<%= @ttevent.issue.project.name%>-<%= @ttevent.issue.subject %>"
start = "<%= @ttevent.start_time.iso8601 %>"
end = "<%= @ttevent.end_time.iso8601 %>"
color = '#3a87ad'
event =
  id: id
  title: title
  start: start
  end: end
  duration: "<%= @ttevent.duration %>"
  color: color
$('#fullcalendar').fullCalendar('renderEvent', event)
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
