class PanelIssueStatusesController < ApplicationController
  layout 'trf1_sjap'
  active_scaffold :"panel_issue_status" do |conf|
  	conf.columns[:panel_issue_status_group].form_ui = :select
    conf.columns[:issue_status].form_ui = :select
  end
end
