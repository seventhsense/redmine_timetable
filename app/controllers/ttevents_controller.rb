class TteventsController < ApplicationController
  # unloadable
  helper :timelog

  def index
    # @ttevents to_gon
    set_issue_lists
    @ttevents = Ttevent.where(user_id: @current_user.id)
    gon.watch.ttevents = @ttevents.to_gon
    respond_to do |format|
      format.html
    end
  end

  def issue_lists
    set_issue_lists   
  end


  def create
    set_user
    @ttevent = Ttevent.new(params[:ttevent])
    @ttevent.user_id = @current_user.id
    issue = @ttevent.issue
    issue.assigned_to_id = @current_user.id
    
    if @ttevent.save! && issue.save!
      set_issue_lists
      msg = '保存しました'
      status = :ok
    else 
      msg = '保存できませんでした.'
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
    respond_to do |format|
      if @ttevent.update(params[:ttevent])
        format.js  {render json: @ttevent, status: :ok}
      else
        format.js
      end
    end
  end

  def update_with_issue
    id = params[:id]
    @ttevent = Ttevent.find(id)
    @issue = @ttevent.issue
    respond_to do |format|
      if @ttevent.update(ttevent_params) && @issue.update(issue_params)
        format.html {redirect_to ttevents_path, notice: 'ttevent was successfully updated.' }
      else
        format.html {redirect_to ttevents_path}
      end
    end
  end

  def destroy
    id = params[:id] 
    @ttevent = Ttevent.find(id)
    @ttevent.destroy
    respond_to do |format|
      format.html { redirect_to ttevents_url, notice: 'ttevent was successfully destroyed.' }
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
    @planned_issues = Issue.open.visible.where(id: planned_issue_ids)
    @issues = Issue.open.visible.where(assigned_to_id: @current_user.id).where.not(id: planned_issue_ids)
    @issues_not_assigned = Issue.open.visible.where(assigned_to_id: nil)
  end

  def ttevent_params
    params[:issue].require(:ttevent).permit(:id, :is_done,:time_entry, :issue,
                                  time_entry: [:id, :hours, :activity_id]
                                   )
  end

  def issue_params
    params.require(:issue).permit(:id, :done_ratio, :status_id, :estimated_hours)
  end

end
