$('#fullcalendar').fullCalendar('addEventSource', gon.ttevent.events)
$('#fullcalendar').fullCalendar('refetchEvents')
$('#tt-events').html("<%=j render partial: 'issue_list', locals: {issues: @issues} %>")
window.location.reload true
