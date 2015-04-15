console.log "<%= @ttevent.id %>"
event = {}
event.id = "<%= @ttevent.id %>"
event.start = "<%= @ttevent.start_time %>"
event.end = "<%= @ttevent.end_time %>"
event.title = "<%= [@ttevent.issue.project.name, @ttevent.issue.subject].join(' - ') %>"
event.color = "green"
console.log event

# $('#fullcalendar').fullCalendar('updateEvent', event)
$('#tt-events').html(
  "<%=j render partial: 'issue_list', locals: {issues: @issues} %>"
)
console.log 'renewal issue lists'
