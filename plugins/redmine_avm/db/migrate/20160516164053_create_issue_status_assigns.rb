# frozen_string_literal: true

class CreateIssueStatusAssigns < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    create_table :issue_status_assigns do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :issue_status
      t.references :issue_field
    end
  end
end
