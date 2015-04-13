class AddTteventIdToTimeEntries < ActiveRecord::Migration
  def self.up
    add_column :time_entries, :ttevent_id, :integer
  end

  def self.down
    remove_column :time_entries, :ttevent_id
  end
end
