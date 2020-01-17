# frozen_string_literal: true

class RemoveDaemonConfigurations < ActiveRecord::Migration
  def change
    drop_table :daemon_configurations do |t|
      t.string :daemon
      t.boolean :autostart, null: false, default: false
      t.integer :sleep_time

      t.timestamps null: false
    end
  end
end
