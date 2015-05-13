class Trf1SjapController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  helper :sort
  include SortHelper  
  
  def index
  end

  def settings
    @trf1_sjap_project = current_trf1_sjap_project
    if request.post? || request.put?
      @trf1_sjap_project.attributes=params[:trf1_sjap_project]
      if @trf1_sjap_project.save
        flash[:notice] = l(:notice_trf1_sjap_project_saved)
        redirect_to url_for(:action => 'settings', 'project_id' => @project.id)
      end
    end
  end
  
  private
  
  def current_trf1_sjap_project
    record = Trf1SjapProject.find_by_project_id(@project.id)
    if record == nil
      record = Trf1SjapProject.new()
    end   
    record.project_id = @project.id 
    return record
  end    
  
end
