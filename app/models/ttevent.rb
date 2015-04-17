class Ttevent < ActiveRecord::Base
  # unloadable
  belongs_to :issue
  has_one :time_entry, dependent: :destroy
  accepts_nested_attributes_for :time_entry

  attr_accessible :id, :title, :start_time, :end_time, :issue_id, :is_done, :time_entry

  before_save :set_duration

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

  def set_duration
    self.duration = (self.end_time - self.start_time) / 60 / 60
  end

end
