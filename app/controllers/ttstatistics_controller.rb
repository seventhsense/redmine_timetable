class TtstatisticsController < ApplicationController
  # unloadable

  def index
    @unreported_ttevents = Ttevent.where('is_done = ? AND end_time < ?',false, Time.now).count
    @ttevents_by_month = Ttevent.where(is_done: true).group_by_month.count
    @ttevents_hours_by_month = Ttevent.where(is_done: true).group_by_month.sum(:duration)
    @ttevents_by_day = Ttevent.where(is_done: true).group_by_day.count
    @ttevents_hours_by_day = Ttevent.where(is_done: true).group_by_day.sum(:duration)
    gon.ttevents = @ttevents_by_month.map {|t| {year: t[0][0], month: t[0][1], count: t[1]}}
  end
end
