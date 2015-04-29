module TteventsHelper
  def set_due_date(issue)
    due_date = issue.due_date
    return 'not-sure' if due_date.nil?
    today = Date.today.in_time_zone
    if due_date < today
      'out-of-time'
    elsif due_date > today.since(3.days)
      'in-time'
    else
      'on-time'
    end
  end
end
