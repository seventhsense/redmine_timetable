class AddColorToTtevents < ActiveRecord::Migration
  def self.up
    add_column :ttevents, :color, :string, default: '#3a87ad'
  end

  def self.down
    remove_column :ttevents, :color
  end
end
