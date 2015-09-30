class CreatePanelIssueStatuses < ActiveRecord::Migration
  def change
    create_table :panel_issue_statuses do |t|
      t.references :issue_status, index: true, foreign_key: true
      t.string :color
      t.references :panel_issue_status_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
