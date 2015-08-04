class CreatePanelIssueStatusGroups < ActiveRecord::Migration
  def change
    create_table :panel_issue_status_groups do |t|
      t.string :name
      t.string :empty_message
      t.boolean :permanent
      t.timestamp :created_on
      t.timestamp :updated_on
    end
  end
end
