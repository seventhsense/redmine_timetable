$(document).ready(function() {
  $('.draggable').draggable({
    revert: true,
    revertDuration: 0
  });
  $('#fullcalendar').fullCalendar({
    timezone: 'local',
    defaultView: 'agendaDay',
    allDaySlot: false,
    header: { center: 'month, agendaWeek, agendaDay'},
    selectable: true,
    selectHelper: true,
    editable: true,

    droppable: true,
    drop: function(date, jsEvent){
      console.log(date);
      console.log(jsEvent);
      console.log(this);
      title = $(this).data('title');
      e = {
        title: title
      };
      $(this).fullCalendar('renderEvent', e);
    }
  });
});

