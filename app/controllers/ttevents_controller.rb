# controller for time table events
class TteventsController < ApplicationController
  # unloadable
  helper :timelog
  helper :issues
  before_action :global_authorize, :set_timezone

  def ttevents_list
    set_issue_lists
    Time.zone = params[:timezone]
    start_time = Time.zone.parse params[:start_time]
    end_time = Time.zone.parse params[:end_time]
    @ttevents = Ttevent.select_for_json
                .where(user_id: @current_user.id,
                       start_time: start_time..end_time)
    render json: @ttevents, status: :ok
  end

  def holiday_list
    Time.zone = params[:timezone]
    holidays = HolidayJp.between(
      Time.zone.parse(params[:start_time]),
      Time.zone.parse(params[:end_time]))
    @holidays = holidays.map do |holiday|
      { id: 'holiday',
        title: holiday.name,
        start: holiday.date.to_time.iso8601,
        end: holiday.date.to_time.iso8601,
        allDay: true, stick: true,
        color: '#ff8888' }
    end
    render json: @holidays, status: :ok
  end

  def index
    set_issue_lists
  end

  def get_ttevent
    @ttevent = Ttevent.where(issue_id: params[:id], is_done: false).take
    render json: @ttevent, status: :ok
  end

  def issue_lists
    set_issue_lists
  end

  def new_issue
    set_user
    @issue = Issue.new
    @issue.ttevents.build(
      start_time: Time.zone.parse(params[:ttevent][:start_time]),
      end_time: Time.zone.parse(params[:ttevent][:end_time])
    )
    @priorities = IssuePriority.active
  end

  def tracker_list
    id = params[:id]
    @trackers = Project.find(id).trackers

    render json: @trackers, status: :ok
  end

  def create_issue
    params[:issue][:due_date] = params[:issue][:due_date].in_time_zone \
                                if params[:issue][:due_date].present?
    @issue = Issue.new(params[:issue])
    if @issue.save
      @ttevent = @issue.ttevents.last
      render
    else
      render json: @issue.errors, status: :unprocessable_entry
    end
  end

  def create
    set_user
    @ttevent = Ttevent.new(params[:ttevent])
    @ttevent.user_id = @current_user.id
    issue = @ttevent.issue
    issue.assigned_to_id = @current_user.id
    @ttevent.end_time = @ttevent.start_time + 30.minutes \
                        if @ttevent.end_time == @ttevent.start_time
    if @ttevent.save! && issue.save!
      set_issue_lists
      msg = l(:saved)
      status = :ok
    else
      msg = l(:not_saved)
      status = :error
    end
    render json: @ttevent, msg: msg, status: status
  end

  def edit
    set_user
    @ttevent = Ttevent.find(params[:id])
    @allowed_statuses = @ttevent.issue.new_statuses_allowed_to(@current_user)
    @project = @ttevent.issue.project
    if @ttevent.time_entry.nil?
      @ttevent.build_time_entry(
        project: @ttevent.issue.project,
        user: @current_user,
        issue: @ttevent.issue
      )
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    @ttevent = Ttevent.find(params[:id])
    if @ttevent.is_done
      start_time = DateTime.parse params[:ttevent][:start_time]
      end_time = DateTime.parse params[:ttevent][:end_time]
      duration = ((end_time - start_time) * 24).to_f
      @ttevent.time_entry.hours = duration
      @ttevent.time_entry.spent_on = start_time
    end

    respond_to do |format|
      if @ttevent.update(params[:ttevent])
        format.js
      else
        @error = true
        format.js
      end
    end
  end

  def update_with_issue
    params[:issue][:due_date] = params[:issue][:due_date].in_time_zone \
                                if params[:issue][:due_date].present?
    @ttevent = Ttevent.find(params[:id])
    @issue = @ttevent.issue
    is_done = ttevent_params[:is_done]
    # create TimeEntry when is_done become true
    if @ttevent.time_entry.nil? && is_done == '1'
      @ttevent.build_time_entry(
        issue_id: @ttevent.issue.id,
        hours: time_entry_params[:hours],
        activity_id: time_entry_params[:activity_id],
        spent_on: time_entry_params[:spent_on],
        comments: time_entry_params[:comments]
      )
      set_user
      @ttevent.time_entry.user_id = @current_user.id
    end
    # update TimeEntry when is_done is already true
    if @ttevent.is_done
      @ttevent.time_entry.activity_id = time_entry_params[:activity_id]
      @ttevent.time_entry.comments = time_entry_params[:comments]
    end

    respond_to do |format|
      if @issue.update(issue_params) && @ttevent.update(ttevent_params)
        # destroy TimeEntry when is_done become false
        if @ttevent.is_done == false && @ttevent.time_entry
          @ttevent.time_entry.destroy
        end
        format.js
      else
        @error = true
        format.js
      end
    end
  end

  def destroy
    id = params[:id]
    @ttevent = Ttevent.find(id)
    @ttevent.destroy
    respond_to do |format|
      format.js
    end
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
    else
      @timezone = Time.zone.name
    end
  end

  def set_issue_lists
    # search @issues
    set_user
    planned_issue_ids =
      Ttevent.where(user_id: @current_user.id, is_done: false).pluck(:issue_id)
    @planned_issues = Issue.open.visible.where(id: planned_issue_ids)
                      .order(:due_date).order(:start_date).includes(:project)
    @issues = Issue.open.visible.where(assigned_to_id: @current_user.id)
              .where.not(id: planned_issue_ids).includes(:project)
    @issues_not_assigned = Issue.open.visible.where(assigned_to_id: nil)
                           .includes(:project)
  end

  def ttevent_params
    params[:issue].require(:ttevent)
      .permit(:id, :is_done, :time_entry, :issue,
              time_entry: [:id, :hours, :activity_id]
             )
  end

  def issue_params
    params.require(:issue)
      .permit(:id, :done_ratio, :status_id, :due_date)
  end

  def time_entry_params
    params[:issue].require(:time_entry)
      .permit(:id, :hours, :spent_on, :activity_id, :comments)
  end

  def global_authorize
    set_user
    render_403 unless @current_user.type == 'User'
  end
end
