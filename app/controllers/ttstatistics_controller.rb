class TtstatisticsController < ApplicationController
  # unloadable
  before_action :set_user,:set_notice, only: [:index, :stats_by_month, :stats_by_day]

  def index
  end

  def stats_by_month
    @ttevents_by_month = Ttevent.planned.done.group_by_month.count
    @ttevents_hours_by_month = Ttevent.planned.done.group_by_month.sum(:duration)
  end

  def stats_by_day
    aggregation = Ttevent.planned.done.order("start_time DESC").group_by_day.count
    @ttevents_average = get_average(aggregation)
    @ttevents_max = aggregation.values.max
    @ttevents_max_date = Date.parse(aggregation.key(@ttevents_max).join('-')).strftime("%Y年 %m月 %d日")

    aggregation_hour = Ttevent.planned.done.order("start_time DESC").group_by_day.sum(:duration)
    @ttevents_hour_average = get_average(aggregation_hour)
    @ttevents_hour_max = aggregation_hour.values.max
    @ttevents_hour_max_date = Date.parse(aggregation_hour.key(@ttevents_hour_max).join('-')).strftime("%Y年 %m月 %d日")


    @ttevents_by_day = Ttevent.planned.done.order("start_time DESC").group_by_day.limit(10).count
    @ttevents_hours_by_day = Ttevent.planned.done.order("start_time DESC").group_by_day.limit(10).sum(:duration)
  end

  private
  def set_user
    @current_user ||= User.current
  end

  def set_notice
    @unreported_ttevents_count = Ttevent.where('is_done = ? AND end_time < ?',false, Time.now).count
    planned_issue_ids = Ttevent.where(user_id: @current_user.id, is_done:false).pluck(:issue_id)
    @unplanned_ttevents_count = Issue.open.visible.where(assigned_to_id: @current_user.id).where.not(id: planned_issue_ids).count
    @issues_not_assigned_count = Issue.open.visible.where(assigned_to_id: nil).count
  end

  def get_average(aggregation)
    duration_array = aggregation.values
    (duration_array.inject(0.0){|r,i| r+=i}/duration_array.size).round(1)
  end
end
