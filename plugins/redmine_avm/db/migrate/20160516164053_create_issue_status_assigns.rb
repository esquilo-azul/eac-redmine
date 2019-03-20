class CreateIssueStatusAssigns < ActiveRecord::Migration
  def change
    create_table :issue_status_assigns do |t|
      t.references :issue_status
      t.references :issue_field
    end
  end
end
