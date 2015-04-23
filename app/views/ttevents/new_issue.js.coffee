options =
  width: 600
  height: 500
  modal: true
  close: ()->
    dialog.dialog("destroy")
console.log('new issue')
$('#modal_area')
  .html('<%=j render :partial => 'new_issue', :locals => {:issue => @issue} %>')
  .hide()
dialog = $('#dialog').dialog(options).show('blind')
