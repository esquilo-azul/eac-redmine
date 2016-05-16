class IssueStatusAssign < ActiveRecord::Base
  belongs_to :issue_status, dependent: :destroy
  belongs_to :issue_field, class_name: 'CustomField', dependent: :destroy

  validates :issue_status, presence: true, uniqueness: true
  validates :issue_field, presence: true
end
