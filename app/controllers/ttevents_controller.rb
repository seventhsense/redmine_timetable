class TteventsController < ApplicationController
  # unloadable
  helper :timelog
  helper :issues

  def index
    # @ttevents to_gon
    set_issue_lists
    @ttevents = Ttevent.where(user_id: @current_user.id)
    gon.ttevents = @ttevents.to_gon
    respond_to do |format|
      format.html
    end
  end

  def issue_lists
    set_issue_lists   
  end

  def new_issue
    @issue = Issue.new
    @issue.ttevents.build
    @priorities = IssuePriority.active
  end

  def create_issue
    
  end

  def create
    set_user
    @ttevent = Ttevent.new(params[:ttevent])
    @ttevent.user_id = @current_user.id
    issue = @ttevent.issue
    issue.assigned_to_id = @current_user.id
    @ttevent.end_time = @ttevent.start_time + 30.minutes if @ttevent.end_time == @ttevent.start_time
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
        project: @ttevent.issue.project ,
        user: @current_user,
        issue: @ttevent.issue
      )
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    id = params[:id]
    @ttevent = Ttevent.find(id)
    if @ttevent.is_done
      start_time = DateTime.parse params[:ttevent][:start_time]
      end_time = DateTime.parse params[:ttevent][:end_time]
      duration = ((end_time - start_time) * 24).to_f
      @ttevent.time_entry.hours = duration
      @ttevent.time_entry.spent_on = start_time
    end

    respond_to do |format|
      if @ttevent.update(params[:ttevent])
        format.js {render json: @ttevent, status: :ok}
      else
        format.js {render json: @ttevent, status: :error}
      end
    end
  end

  def update_with_issue
    id = params[:id]
    @ttevent = Ttevent.find(id)
    @issue = @ttevent.issue
    is_done = ttevent_params[:is_done]
    # 終了時にTimeEntry作成
    if @ttevent.time_entry.nil? && is_done == "1"
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
    #　すでに終了している場合には更新する
    if @ttevent.is_done
      @ttevent.time_entry.activity_id = time_entry_params[:activity_id]
    end
    respond_to do |format|
      if @ttevent.update(ttevent_params) && @issue.update(issue_params) 
        # 終了フラグを解除した場合はTimeEntryを削除する
        if @ttevent.is_done == false && @ttevent.time_entry
          @ttevent.time_entry.destroy
        end
        format.html {redirect_to ttevents_path, notice: l(:notice_successful_update) }
      else
        format.html {redirect_to ttevents_path, alert: l(:error_something_went_wrong)}
      end
    end
  end

  def destroy
    id = params[:id] 
    @ttevent = Ttevent.find(id)
    @ttevent.destroy
    respond_to do |format|
      format.html { redirect_to ttevents_url, notice: l(:notice_successful_delete) }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @current_user ||= User.current
  end

  def set_issue_lists
    # search @issues
    set_user
    planned_issue_ids = Ttevent.where(user_id: @current_user.id, is_done:false).pluck(:issue_id)
    @planned_issues = Issue.includes(:project).open.visible.where(id: planned_issue_ids)
    @issues = Issue.open.visible.where(assigned_to_id: @current_user.id).where.not(id: planned_issue_ids)
    @issues_not_assigned = Issue.open.visible.where(assigned_to_id: nil)
  end

  def ttevent_params
    params[:issue].require(:ttevent)
      .permit(:id, :is_done,:time_entry, :issue,
              time_entry: [:id, :hours, :activity_id]
             )
  end

  def issue_params
    params.require(:issue)
      .permit(:id, :done_ratio, :status_id)
  end

  def time_entry_params
    params[:issue].require(:time_entry)
      .permit(:id, :hours, :spent_on, :activity_id, :comments)
  end
end
