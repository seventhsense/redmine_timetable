$('#tt-events').html(
  "<%=j render partial: 'issue_list', locals: {issues: @issues} %>"
)
# 初期処理
$('#tt-events .draggable').each(() ->
  $(this).not('.ui-draggable-disabled').draggable
    revert: true,
    revertDuration: 0
  $(this).data('event',
    title: $.trim($(this).text()),
    stick: true,
    issue_id: $.trim($(this).data('issue_id'))
  )
)
