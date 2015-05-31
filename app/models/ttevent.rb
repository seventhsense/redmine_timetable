# class Ttevent is for time table event.
class Ttevent < ActiveRecord::Base
  # unloadable
  belongs_to :issue
  belongs_to :user
  has_one :time_entry, dependent: :destroy
  accepts_nested_attributes_for :time_entry

  attr_accessible :id, :title, :start_time, :end_time, :issue_id, :is_done,
                  :time_entry, :user_id, :color

  before_save :set_duration, :define_color

  def self.planned
    current_user = User.current
    where(user_id: current_user.id)
  end

  def self.done
    where(is_done: true)
  end

  def self.undone
    where(is_done: false)
  end

  def self.select_for_json
    adapter = ActiveRecord::Base.connection.instance_values['config'][:adapter]
    case adapter
    when /sqlite3/ then
      joins(issue: :project).select(
        'ttevents.id as id,
         ttevents.start_time as start,
         ttevents.end_time as end,
         ttevents.color as color,
         ttevents.issue_id as issue_id,
         ttevents.user_id as user_id,
         ttevents.time_entry_id as time_entry_id,
         ttevents.is_done as is_done,
         ttevents.duration as duration,
         issues.subject||" - "|| projects.name as title'
      )
    when 'mysql', 'mysql2' then
      joins(issue: :project).select(
        'ttevents.id as id,
         ttevents.start_time as start,
         ttevents.end_time as end,
         ttevents.color as color,
         ttevents.issue_id as issue_id,
         ttevents.user_id as user_id,
         ttevents.time_entry_id as time_entry_id,
         ttevents.is_done as is_done,
         ttevents.duration as duration,
         CONCAT(issues.subject," - ", projects.name) as title'
      )
    when /postgresql/ then
      # TODO: need postgresql grouping
      all
    else
      all
    end
  end

  def self.select_month
    adapter = ActiveRecord::Base.connection.instance_values['config'][:adapter]
    case adapter
    when /sqlite3/ then
      select(
        'count(id) as count,
         sum(duration) as sum,
         strftime("%Y", datetime(start_time, "localtime")) as year,
         strftime("%m", datetime(start_time, "localtime")) as month'
      )
    when 'mysql', 'mysql2' then
      select(
        'count(id) as count, sum(duration) as sum,
         YEAR(start_time) as year,
         MONTH(start_time) as month'
      )
    when /postgresql/ then
      # TODO: need postgresql grouping
      all
    else
      all
    end
  end

  def self.select_day
    adapter = ActiveRecord::Base.connection.instance_values['config'][:adapter]
    case adapter
    when /sqlite3/ then
      select('count(id) as count, sum(duration) sum, strftime("%Y", datetime(start_time, "localtime")) as year, strftime("%m", datetime(start_time, "localtime")) as month, strftime("%d", datetime(start_time, "localtime")) as day')
    when 'mysql', 'mysql2' then
      select('count(id) as count, sum(duration) as sum, YEAR(start_time) as year, MONTH(start_time) as month, DAY(start_time) as day')
    when /postgresql/ then
      # TODO: need postgresql grouping
      all
    else
      all
    end
  end

  def self.group_by_month
    adapter = ActiveRecord::Base.connection.instance_values['config'][:adapter]
    case adapter
    when /sqlite3/ then
      group('strftime("%Y", datetime(start_time, "localtime"))').group('strftime("%m", datetime(start_time, "localtime"))')
    when 'mysql', 'mysql2' then
      group('YEAR(start_time)').group('MONTH(start_time)')
    when /postgresql/ then
      # TODO: need postgresql grouping testing
      group('date_trunc("year", start_time)').group('date_trunc("month", start_time)')
    else
      all
    end
  end

  def self.group_by_day
    adapter = ActiveRecord::Base.connection.instance_values['config'][:adapter]
    case adapter
    when /sqlite3/ then
      group('strftime("%Y", datetime(start_time, "localtime"))').group('strftime("%m", datetime(start_time, "localtime"))').group('strftime("%d", datetime(start_time, "localtime"))')
    when 'mysql', 'mysql2' then
      group('YEAR(start_time)').group('MONTH(start_time)').group('DAY(start_time)')
    when /postgresql/ then
      # TODO: need postgresql grouping test
      group('date_trunc("year", start_time)').group('date_trunc("month", start_time)').group('date_trunc("day", start_time)')
    else
      all
    end
  end

  private

  def set_duration
    self.duration = (end_time - start_time) / 60 / 60
  end

  def define_color
    return self.color = 'darkgrey' if is_done
    due_date = issue.due_date
    return self.color = '#da3aad' if due_date.nil?
    end_date = end_time.to_date
    if due_date < end_date # out of time
      self.color = '#da3a3a'
    elsif due_date > end_date.since(3.days) # in time
      self.color = '#3aad87'
    else # on time
      self.color = '#da873a'
    end
  end
end
