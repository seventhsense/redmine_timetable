module TimeEntryPatch
  def self.included(base) # :nodoc:
    base.class_eval do
      # unloadable # Send unloadable so it will not be unloaded in development
      belongs_to :ttevent
      
    end
 
  end

end

TimeEntry.include TimeEntryPatch
