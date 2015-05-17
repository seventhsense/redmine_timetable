event = window_event
event.color = "<%= @ttevent.color %>"
$('#fullcalendar').fullCalendar('updateEvent', event)
# $('#fullcalendar').fullCalendar('refetchEvents')
delete window_event
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
