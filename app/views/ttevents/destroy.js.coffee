$('#dialog').dialog('close')
$('#modal_area').html('')
console.log event
event = window_event
console.log event.id
console.log typeof(event.id)

$('#fullcalendar').fullCalendar('removeEvents', event.id)
delete window_event
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
console.log 'get list'
