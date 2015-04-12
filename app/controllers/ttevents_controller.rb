class TteventsController < ApplicationController
  # unloadable

  def index
    current_user ||= User.current
    @ttevents = Ttevent.where(user_id: current_user.id)
    planned_issue_ids = Ttevent.where(user_id: current_user.id, is_done:false).pluck(:issue_id)
    @planned_issues = Issue.open.visible.where(id: planned_issue_ids)
    @issues = Issue.open.visible.where(assigned_to_id: current_user.id).where.not(id: planned_issue_ids)
    @issues_not_assigned = Issue.where(assigned_to_id: nil)
    gon.ttevents = @ttevents.to_gon
    respond_to do |format|
      format.html
    end
  end

  def create
    @ttevent = Ttevent.new(params[:ttevent])
    @ttevent.user_id = User.current.id
    @ttevent.issue.assigned_to_id = User.current.id
    if @ttevent.save!
      current_user ||= User.current
      @ttevents = Ttevent.where(user_id: current_user.id)
      gon.ttevents = @ttevents.to_gon
      msg = '保存しました'
    else 
      msg = '保存できませんでした.'
    end
    respond_to do |format|
      format.js 
    end
    # redirect_to ttevents_path, format: :html
  end

  def edit
    @ttevent = Ttevent.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    id = params[:id]
    @ttevent = Ttevent.find(id)
    @ttevent.update(params[:ttevent])
    respond_to do |format|
      format.html {redirect_to ttevents_path}
      format.js
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
end
