class CreateTtevents < ActiveRecord::Migration
  def change
    create_table :ttevents do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :issue_id
      t.integer :user_id
      t.integer :time_entry_id
      t.boolean :is_done, default: false

      t.index :start_time
      t.index :end_time
      t.index :is_done
    end
  end
end
