$('#dialog').dialog('close')
$('#modal_area').html('')
event = window.event
$('#fullcalendar').fullCalendar('removeEvents', event.id)
delete window.event
$.ajax
  type: 'GET'
  url: "ttevents/issue_lists"
console.log 'get list'
