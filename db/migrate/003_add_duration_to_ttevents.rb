class AddDurationToTtevents < ActiveRecord::Migration
  def self.up
    add_column :ttevents, :duration, :float
  end

  def self.down
    remove_column :ttevents, :duration
  end
end
