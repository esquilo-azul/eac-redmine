# frozen_string_literal: true

class IssueStatusAssignsController < ApplicationController
  before_action :require_admin, :active_scaffold_set_dynamic_options
  layout 'admin'

  active_scaffold :issue_status_assign do |conf|
    conf.columns[:issue_status].form_ui = :select
    conf.columns[:issue_field].form_ui = :select
  end

  private

  def active_scaffold_set_dynamic_options
    active_scaffold_config.columns[:issue_field].options =
      { options: issue_field_options }
  end

  def issue_field_options
    CustomField.where(type: 'IssueCustomField', field_format: 'user')
               .map { |cf| [cf.id, cf.to_s] }
  end
end
