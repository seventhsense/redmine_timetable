module IssuePatch
  def self.included(base) # :nodoc:
    base.class_eval do
      #unloadable # Send unloadable so it will not be unloaded in development
      has_many :ttevents, dependent: :destroy
      accepts_nested_attributes_for :ttevents
      
    end
 
  end

end

Issue.include IssuePatch
