# frozen_string_literal: true

class RemoveDaemonConfigurations  < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    drop_table :daemon_configurations do |t|
      t.string :daemon
      t.boolean :autostart, null: false, default: false
      t.integer :sleep_time

      t.timestamps null: false
    end
  end
end
