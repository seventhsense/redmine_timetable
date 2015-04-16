module IssuePatch
  def self.included(base) # :nodoc:
    base.class_eval do
      #unloadable # Send unloadable so it will not be unloaded in development
      has_many :ttevents
      
    end
 
  end

end

Issue.include IssuePatch
