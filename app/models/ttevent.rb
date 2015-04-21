class Ttevent < ActiveRecord::Base
  # unloadable
  belongs_to :issue
  has_one :time_entry, dependent: :destroy
  accepts_nested_attributes_for :time_entry

  attr_accessible :id, :title, :start_time, :end_time, :issue_id, :is_done, :time_entry

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

  def self.group_by_month
    adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    case adapter
    when /sqlite3/ then
      group('strftime("%Y", start_time)').group('strftime("%m", start_time)')
    when 'mysql', 'mysql2' then
      group('YEAR(start_time)').group('MONTH(start_time)')
    when /postgresql/ then
      # TODO need postgresql grouping
      all
    else
      all
    end

  end

  def self.group_by_day
    adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    case adapter
    when /sqlite3/ then
      group('strftime("%Y", start_time)').group('strftime("%m", start_time)').group('strftime("%d", start_time)')
    when 'mysql', 'mysql2' then
      group('YEAR(start_time)').group('MONTH(start_time)').group('DAY(start_time)')
    when /postgresql/ then
      # TODO need postgresql grouping
      all
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
      color = obj.is_done ? 'darkgrey' : 'green'
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

  # def duration
    # (self.end_time - self.start_time) / 60 / 60
  # end
  private
  def set_duration
    self.duration = (self.end_time - self.start_time) / 60 / 60
  end

end
