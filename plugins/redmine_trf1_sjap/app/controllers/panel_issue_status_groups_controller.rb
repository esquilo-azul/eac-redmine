class PanelIssueStatusGroupsController < ApplicationController
  def index
    @panel_issue_status_groups = PanelIssueStatusGroup.all
  end
end
