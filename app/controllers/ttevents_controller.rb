class TteventsController < ApplicationController
  # unloadable

  def index
    # @ttevents to_gon
    set_issue_lists
    @ttevents = Ttevent.where(user_id: @current_user.id)
    gon.watch.ttevents = @ttevents.to_gon
    respond_to do |format|
      format.html
    end
  end

  def create
    set_issue_lists
    @ttevent = Ttevent.new(params[:ttevent])
    @ttevent.user_id = @current_user.id
    issue = @ttevent.issue
    issue.assigned_to_id = @current_user.id
    gon.ttevent = @ttevent
    
    if @ttevent.save! && issue.save!
      current_user ||= User.current
      set_issue_lists
      msg = '保存しました'
    else 
      msg = '保存できませんでした.'
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @ttevent = Ttevent.find(params[:id])
    @allowed_statuses = @ttevent.issue.new_statuses_allowed_to(User.current)
    @project = @ttevent.issue.project
    respond_to do |format|
      format.js
    end
  end

  def update
    id = params[:id]
    @ttevent = Ttevent.find(id)
    respond_to do |format|
      if @ttevent.update(params[:ttevent])
        format.js
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
      if @ttevent.update(params[:ttevent]) && @issue.update(params[:ttevent][:issue])
        format.html {redirect_to ttevents_path}
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
  def set_issue_lists
    # search @issues
    @current_user ||= User.current
    planned_issue_ids = Ttevent.where(user_id: @current_user.id, is_done:false).pluck(:issue_id)
    @planned_issues = Issue.open.visible.where(id: planned_issue_ids)
    @issues = Issue.open.visible.where(assigned_to_id: @current_user.id).where.not(id: planned_issue_ids)
    @issues_not_assigned = Issue.open.visible.where(assigned_to_id: nil)
  end

end
