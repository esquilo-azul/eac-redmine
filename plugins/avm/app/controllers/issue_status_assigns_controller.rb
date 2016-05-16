class IssueStatusAssignsController < ApplicationController
  before_action :require_admin
  layout 'admin_active_scaffold'

  def self.issue_field_options
    cfs = CustomField.where(type: 'IssueCustomField', field_format: 'user')
    cf = cfs.first
    [[cf.id, cf.to_s]]
    # cfs.map { |n| [n.id, n] }
  end

  active_scaffold :issue_status_assign do |conf|
    conf.columns[:issue_status].form_ui = :select
    conf.columns[:issue_field].options = { options: issue_field_options }
    conf.columns[:issue_field].form_ui = :select
  end
end
