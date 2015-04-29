require 'csv'
class TtstatisticsController < ApplicationController
  # unloadable
  before_action :set_timezone
  before_action :set_user,:set_notice, only: [:index, :stats_by_month, :stats_by_day, :daily_report, :business]

  def index
    # イベントの状況
    aggregation = Ttevent.planned.done.order("start_time DESC").group_by_day.count
    unless aggregation == 0
      @ttevents_average = get_average(aggregation)
      @ttevents_max = aggregation.values.max
      ## localization
      @ttevents_max_date = Date.parse(aggregation.key(@ttevents_max).join('-')).strftime("%Y年 %m月 %d日") if aggregation.key @ttevents_max
    end

    aggregation_hour = Ttevent.planned.done.order("start_time DESC").group_by_day.sum(:duration)
    unless aggregation_hour == 0
      @ttevents_hour_average = get_average(aggregation_hour)
      @ttevents_hour_max = aggregation_hour.values.max
      ## localization
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
    # count issue and project
    months = ['x']
    projects = ['担当プロジェクト数']
    issues = ['担当チケット数']
    newly_issues = ['新規チケット数']
    done_issues = ['終了チケット数']
    # TODO this is for sqlite3 only
    case ActiveRecord::Base.connection.instance_values["config"][:adapter]
    when /sqlite3/ then
      ni = Issue.select('subject, count(id) as count, strftime("%Y", datetime(created_on, "localtime")) as year,strftime("%m", datetime(created_on, "localtime")) as month').where(assigned_to_id: @current_user.id).group('strftime("%Y", datetime(created_on, "localtime"))').group('strftime("%m", datetime(created_on, "localtime"))').to_json(except: [:subject, :id])
      di = Issue.select('subject, count(id) as count, strftime("%Y", datetime(closed_on, "localtime")) as year,strftime("%m", datetime(closed_on, "localtime")) as month').where(assigned_to_id: @current_user.id).where('closed_on IS NOT NULL').group('strftime("%Y", datetime(closed_on, "localtime"))').group('strftime("%m", datetime(closed_on, "localtime"))').to_json(except: [:subject, :id])
    when 'mysql', 'mysql2' then
      ni = Issue.where(assigned_to_id: @current_user.id).group('YEAR(created_on)').group('MONTH(created_on)').count
      # di = Issue.where(assigned_to_id: @current_user.id).where('closed_on IS NOT NULL').group('YEAR(closed_on)').group('MONTH(closed_on)'.count
    #when /postgresql/ then
      # TODO need postgresql grouping testing
      # group('date_trunc("year", start_time)').group('date_trunc("month", start_time)')   
    else
      ni = Issue.none
      di = Issue.none
    end

    gon.newly_issues_count = ni
    gon.done_issues_count = di

    gon.project_ratio = Ttevent.planned.done.joins(issue: :project).group('projects.name').sum(:duration).to_a
  end

  def stats_by_month
    @ttevents = Ttevent.select_month.planned.done.order("start_time DESC").group_by_month
    dates = ['x']
    counts = ['個数']
    sums = ['時間']
    @ttevents.each do |data|
      dates << "#{data.year}#{data.month}01"
      counts << data.count
      sums << data.sum
    end
    gon.ttevents = [dates, counts, sums]
  end

  def stats_by_day
    @ttevents = Ttevent.select_day.planned.done.order("start_time DESC").group_by_day.limit(10)
    dates = ['x']
    counts = ['個数']
    sums = ['時間']
    @ttevents.each do |data|
      dates << "#{data.year}#{data.month}#{data.day}"
      counts << data.count
      sums << data.sum
    end
    gon.ttevents = [dates, counts, sums]
  end

  def daily_report
    @date = params[:date] ? Time.zone.parse(params[:date]) : Time.current
    one_day = @date.all_day
    @ttevents = Ttevent.planned.done.where(start_time: one_day).order(:start_time).includes(:time_entry, issue: {project: :parent})

    respond_to do |format|
      format.html
      format.js
      format.csv {send_data generate_csv(@ttevents), type: 'text/csv; charset=shift_jis', filename: generate_filename(@date)}
    end
  end

  def business
    
  end

  private
  def set_user
    @current_user ||= User.current
  end

  def set_timezone
    set_user
    @timezone = @current_user.pref.time_zone
    if @timezone.present?
      Time.zone = @timezone
    end
    logger.debug Time.zone.name
    logger.debug @timezone
  end

  def set_notice
    @unreported_ttevents_count = Ttevent.where('is_done = ? AND end_time < ? AND user_id = ?',false, Time.current, @current_user.id).count
    planned_issue_ids = Ttevent.where(user_id: @current_user.id, is_done:false).pluck(:issue_id)
    @unplanned_ttevents_count = Issue.open.visible.where(assigned_to_id: @current_user.id).where.not(id: planned_issue_ids).count
    @issues_not_assigned_count = Issue.open.visible.where(assigned_to_id: nil).count
  end

  def get_average(aggregation)
    return if aggregation == 0
    duration_array = aggregation.values
    (duration_array.inject(0.0){|r,i| r+=i}/duration_array.size).round(1)
  end

  def generate_csv(ttevents)
    # localization
    headers = %w(開始時刻 時間 プロジェクト名 チケット名 作業内容)
    data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      ttevents.each do |ttevent|
        csv << [
          ttevent.start_time.in_time_zone.strftime('%H:%M'),
          ttevent.duration,
          ttevent.issue.project.name,
          ttevent.issue.subject,
          TimeEntryActivity.find(ttevent.time_entry.activity_id)
        ]
      end
    end
    data.encode(Encoding::SJIS)
  end

  def generate_filename(date)
    date.strftime('%Y-%m-%d') + '.csv'
  end
end
