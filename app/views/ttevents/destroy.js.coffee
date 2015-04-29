$('#dialog').dialog('close')
$('#modal_area').html('')
event = window_event
console.log event.id
console.log typeof(event.id)
id = <%= @ttevent.id %>

$('#fullcalendar').fullCalendar('removeEvents', id)
delete window_event
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
console.log 'get list'
