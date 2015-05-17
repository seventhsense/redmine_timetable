options =
  width: 500
  height: 290
  modal: true
  close: ()->
    dialog.dialog("destroy")
console.log('new issue')
$('#modal_area')
  .html('<%=j render :partial => 'new_issue', :locals => {:issue => @issue} %>')
  .hide()
dialog = $('#dialog').dialog(options).show('blind')
