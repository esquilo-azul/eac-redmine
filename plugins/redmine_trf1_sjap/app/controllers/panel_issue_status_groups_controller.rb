class PanelIssueStatusGroupsController < ApplicationController
  before_action :set_panel_issue_status_group, only: [:edit, :update]
  
  def index
    @panel_issue_status_groups = PanelIssueStatusGroup.all
  end
  
  def new
  	@panel_issue_status_group = PanelIssueStatusGroup.new
  end

  def edit
  end

  def create
    @panel_issue_status_group = PanelIssueStatusGroup.new(panel_issue_status_group_params)
    if @panel_issue_status_group.save
      redirect_to panel_issue_status_groups_url, notice: 'Message was successfully created.'
    else
      render :new
    end
  end

  def update
    if @panel_issue_status_group.update(panel_issue_status_group_params)
      redirect_to panel_issue_status_groups_url, notice: 'Message was successfully updated'
    else
      render :edit
    end
  end
  
  def destroy
    @panel_issue_status_group = PanelIssueStatusGroup.find(params[:id])
    if @panel_issue_status_group.present?
       @panel_issue_status_group.destroy
    end
    redirect_to panel_issue_status_groups_url, notice: 'Message fase was successfully destroyed.'
  end

  private
    def set_panel_issue_status_group  
      @panel_issue_status_group = PanelIssueStatusGroup.find(params[:id])
    end
      
    def panel_issue_status_group_params
      params.require(:panel_issue_status_group).permit(:name, :empty_message, :permanent)
  end
end
