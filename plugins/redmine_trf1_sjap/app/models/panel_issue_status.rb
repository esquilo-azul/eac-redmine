class PanelIssueStatus < ActiveRecord::Base
  unloadable
  belongs_to :issue_status
  belongs_to :panel_issue_status_group
end
