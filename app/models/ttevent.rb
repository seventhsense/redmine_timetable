class Ttevent < ActiveRecord::Base
  # unloadable
  belongs_to :issue
  has_one :time_entry, dependent: :destroy
  accepts_nested_attributes_for :time_entry

  attr_accessible :id, :title, :start_time, :end_time, :issue_id, :is_done, :time_entry, :user_id

  before_save :set_duration

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

  def self.select_month
    adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    case adapter
    when /sqlite3/ then
      select('count(id) as count, sum(duration) as sum, strftime("%Y", datetime(start_time, "localtime")) as year, strftime("%m", datetime(start_time, "localtime")) as month')
    when 'mysql', 'mysql2' then
      select('count(id) as count, sum(duration) as sum, YEAR(start_time) as year, MONTH(start_time) as month')
    when /postgresql/ then
      # TODO need postgresql grouping
      all
    else
      all
    end
  end

  def self.select_day
    adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    case adapter
    when /sqlite3/ then
    select('count(id) as count, sum(duration) sum, strftime("%Y", datetime(start_time, "localtime")) as year, strftime("%m", datetime(start_time, "localtime")) as month, strftime("%d", datetime(start_time, "localtime")) as day')
    when 'mysql', 'mysql2' then
      select('count(id) as count, sum(duration) as sum, YEAR(start_time) as year, MONTH(start_time) as month, DAY(start_time) as day')
    when /postgresql/ then
      # TODO need postgresql grouping
      all
    else
      all
    end

  end

  def self.group_by_month
    adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    case adapter
    when /sqlite3/ then
      group('strftime("%Y", datetime(start_time, "localtime"))').group('strftime("%m", datetime(start_time, "localtime"))')
    when 'mysql', 'mysql2' then
      group('YEAR(start_time)').group('MONTH(start_time)')
    when /postgresql/ then
      # TODO need postgresql grouping
      group('date_trunc("year", start_time)').group('date_trunc("month", start_time)')   
    else
      all
    end
  end

  def self.group_by_day
    adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    case adapter
    when /sqlite3/ then
      group('strftime("%Y", datetime(start_time, "localtime"))').group('strftime("%m", datetime(start_time, "localtime"))').group('strftime("%d", datetime(start_time, "localtime"))')
    when 'mysql', 'mysql2' then
      group('YEAR(start_time)').group('MONTH(start_time)').group('DAY(start_time)')
    when /postgresql/ then
      # TODO need test postgresql grouping
      group('date_trunc("year", start_time)').group('date_trunc("month", start_time)').group('date_trunc("day", start_time)')
    else
      all
    end
  end

  def self.to_gon
    be = self.all
    s = {}
    s[:events] = []
    be.each do |obj|
      title = [obj.issue.project.name, obj.issue.subject].join('-')
      color = set_color(obj)
      hash = {
        id: obj.id,
        title: title,
        start: obj.start_time,
        end: obj.end_time,
        sticky: true,
        color: color
      }
      s[:events] << hash
    end
    s
  end

  def set_color(ttevent)
    set_color(ttevent)
  end

  private
  def set_duration
    self.duration = (self.end_time - self.start_time) / 60 / 60
  end

  def self.set_color(ttevent)
    return 'darkgrey' if ttevent.is_done
    due_date = ttevent.issue.due_date
    return '#da3aad' if due_date.nil?
    end_date = ttevent.end_time.to_date
    if due_date < end_date
      # out of time
      '#da3a3a'
    elsif due_date > end_date.since(3.days)
      # in time
      '#3aad87'
    else
      # on time
      '#da873a'
    end
  end

end
