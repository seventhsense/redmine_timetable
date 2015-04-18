class TtstatisticsController < ApplicationController
  # unloadable

  def index
    @unreported_ttevents = Ttevent.where('is_done = ? AND end_time < ?',false, Time.now).count
    @ttevents_by_month = Ttevent.where(is_done: true).group('strftime("%m", start_time)').count
    @ttevents_hours_by_month = Ttevent.where(is_done: true).group('strftime("%m", start_time)').sum(:duration)
    gon.ttevents = @ttevents_by_month
  end
end
