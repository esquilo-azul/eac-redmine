# frozen_string_literal: true

class IssueStatusAssign < ActiveRecord::Base
  belongs_to :issue_status, dependent: :destroy
  belongs_to :issue_field, class_name: 'CustomField', dependent: :destroy

  validates :issue_status, presence: true, uniqueness: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :issue_field, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
end
