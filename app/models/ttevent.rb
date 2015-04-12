class Ttevent < ActiveRecord::Base
  # unloadable
  attr_accessible :id, :title, :start_time, :end_time, :issue_id, :is_done
  belongs_to :issue
  belongs_to :time_entry

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

  def duration
    (self.end_time - self.start_time) / 60 / 60
  end

end
