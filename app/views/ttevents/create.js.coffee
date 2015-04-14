console.log "<%= @ttevent.id %>"
event = {}
event.id = "<%= @ttevent.id %>"
console.log event.id

# $('#fullcalendar').fullCalendar('updateEvent', event)
$('#tt-events').html("<%=j render partial: 'issue_list', locals: {issues: @issues} %>")
console.log 'renewal issue lists'
