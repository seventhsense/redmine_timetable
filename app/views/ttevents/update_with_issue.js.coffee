$('#dialog').dialog('close')
$('#modal_area').html('')
id = "<%= @ttevent.id %>"
title = "<%= @ttevent.issue.project.name%> - <%= @ttevent.issue.subject %>"
start = "<%= @ttevent.start_time.iso8601 %>"
end = "<%= @ttevent.end_time.iso8601 %>"
# TODO set color
color =  "<%=
  if @ttevent.is_done
    '#a9a9a9'
  else
    '#3a87ad'
  end
  %>"
duration = "<%= @ttevent.duration %>"
event = window.event
event.id = id
event.title = title
event.start = start
event.end = end
event.color = color
event.duration = duration
$('#fullcalendar').fullCalendar('updateEvent', event)
delete window.event
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
console.log 'get list'
