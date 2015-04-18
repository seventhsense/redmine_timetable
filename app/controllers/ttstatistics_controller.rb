class TtstatisticsController < ApplicationController
  # unloadable
  before_action :set_unreported_ttevents_count, only: [:index, :stats_by_month, :stats_by_day]

  def index
    @unreported_ttevents = Ttevent.where('is_done = ? AND end_time < ?',false, Time.now).count
  end

  def stats_by_month
    @ttevents_by_month = Ttevent.where(is_done: true).group_by_month.count
    @ttevents_hours_by_month = Ttevent.where(is_done: true).group_by_month.sum(:duration)
  end

  def stats_by_day
    @ttevents_by_day = Ttevent.where(is_done: true).order("start_time DESC").group_by_day.limit(10).count
    @ttevents_hours_by_day = Ttevent.where(is_done: true).order("start_time DESC").group_by_day.limit(10).sum(:duration)
  end

  private
  def set_unreported_ttevents_count
    @unreported_ttevents_count = Ttevent.where('is_done = ? AND end_time < ?',false, Time.now).count
  end
end
