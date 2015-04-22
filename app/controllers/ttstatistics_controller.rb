class TtstatisticsController < ApplicationController
  # unloadable
  before_action :set_user,:set_notice, only: [:index, :stats_by_month, :stats_by_day, :daily_report]

  def index
    # イベントの状況
    aggregation = Ttevent.planned.done.order("start_time DESC").group_by_day.count
    unless aggregation == 0
      @ttevents_average = get_average(aggregation)
      @ttevents_max = aggregation.values.max
      @ttevents_max_date = Date.parse(aggregation.key(@ttevents_max).join('-')).strftime("%Y年 %m月 %d日") if aggregation.key @ttevents_max
    end


    aggregation_hour = Ttevent.planned.done.order("start_time DESC").group_by_day.sum(:duration)
    unless aggregation_hour == 0
      @ttevents_hour_average = get_average(aggregation_hour)
      @ttevents_hour_max = aggregation_hour.values.max
      @ttevents_hour_max_date = Date.parse(aggregation_hour.key(@ttevents_hour_max).join('-')).strftime("%Y年 %m月 %d日") if aggregation_hour.key @ttevents_hour_max
    end

    @ttevents_undone = Ttevent.planned.undone.count 
    @ttevents_undone_hour = Ttevent.planned.undone.sum(:duration)

    # プロジェクトとチケットの状況
    @project_membered_count = Project.active.visible.count
    issues_assigned = Issue.open.visible.where(assigned_to_id: @current_user.id)
    @issues_assigned_count = issues_assigned.count
    pm = 1.month.ago
    last_month = [pm.beginning_of_month..pm.end_of_month]
    @new_issues_assigned_last_month_count = Issue.visible.where(assigned_to_id: @current_user.id).where(start_date: last_month).count
    @end_issues_assigned_last_month_count = Issue.visible.where(assigned_to_id: @current_user.id).where(closed_on: last_month).count
    tm = Date.today
    this_month = [tm.beginning_of_month..tm.end_of_month]
    @new_issues_assigned_this_month_count = Issue.visible.where(assigned_to_id: @current_user.id).where(start_date: this_month).count
    @end_issues_assigned_this_month_count = Issue.visible.where(assigned_to_id: @current_user.id).where(closed_on: this_month).count
  end

  def stats_by_month
    @ttevents = Ttevent.select('count(id) as count, sum(duration) sum, strftime("%Y", start_time) as year, strftime("%m", start_time) as month').planned.done.order("start_time DESC").group_by_month
  end

  def stats_by_day
    @ttevents = Ttevent.select('count(id) as count, sum(duration) sum, strftime("%Y", start_time) as year, strftime("%m", start_time) as month, strftime("%d", start_time) as day').planned.done.order("start_time DESC").group_by_day.limit(10)
  end

  def daily_report
    # TODO think about timezone
    @date = params[:date]? Date.parse(params[:date]) : Date.today
    @date = @date.in_time_zone('Japan')
    one_day = @date.beginning_of_day..@date.end_of_day
    @ttevents = Ttevent.planned.done.where(start_time: one_day)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def set_user
    @current_user ||= User.current
  end

  def set_notice
    @unreported_ttevents_count = Ttevent.where('is_done = ? AND end_time < ? AND user_id = ?',false, Time.now, @current_user.id).count
    planned_issue_ids = Ttevent.where(user_id: @current_user.id, is_done:false).pluck(:issue_id)
    @unplanned_ttevents_count = Issue.open.visible.where(assigned_to_id: @current_user.id).where.not(id: planned_issue_ids).count
    @issues_not_assigned_count = Issue.open.visible.where(assigned_to_id: nil).count
  end

  def get_average(aggregation)
    return if aggregation == 0
    duration_array = aggregation.values
    (duration_array.inject(0.0){|r,i| r+=i}/duration_array.size).round(1)
  end
end
