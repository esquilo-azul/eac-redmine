class PanelIssueStatus < ActiveRecord::Base
  belongs_to :issue_status
  belongs_to :panel_issue_status_group
  validates :color, presence: true, format: {with: /\#[0-9A-F]{6}/i, message: 'Cor deve ter o formato de uma cor html (Ex.: #AA00FF)'}
  validates :issue_status, presence: true
  validates :panel_issue_status_group, presence: true
  validates :issue_status, uniqueness: true
end
