options =
  width: 400
  height: 460
  modal: true
  close: ()->
    dialog.dialog("destroy")
$('#modal_area')
  .html('<%=j render :partial => "edit_ttevent", :locals => {:ttevent => @ttevent} %>')
  .hide()
dialog = $('#dialog').dialog(options).show('blind')
cancel = ->
  dialog.dialog("close")
  $('#modal_area').html('')
