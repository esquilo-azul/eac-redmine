class Trf1SjapController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  helper :sort
  include SortHelper

  def index
  end

  def settings
    @trf1_sjap_project = current_trf1_sjap_project
    if request.patch?
      @trf1_sjap_project.attributes = params.require(:trf1_sjap_project).permit(:eadmin_matricula, :eadmin_senha, :eadmin_banco, :esosti_export_project_id)
      if @trf1_sjap_project.save
        flash[:notice] = l(:notice_trf1_sjap_project_saved)
        redirect_to url_for(:action => 'settings', 'project_id' => @project.id)
      end
    end
    @projects_list = @project.children.map { |p| [p.name, p.id] }
  end

  def eadmin_test_login
    trf1_sjap_project = current_trf1_sjap_project
    session = Trf1Sjap::EadminHttpSession.new(
      trf1_sjap_project.eadmin_matricula,
      trf1_sjap_project.eadmin_senha,
      trf1_sjap_project.eadmin_banco
    )
    loginResult = session.login
    if loginResult === true
      flash[:notice] = 'Login ok'
    else
      flash[:error] = 'Login falhou com a seguinte mensagem "' + loginResult + '"'
    end
    redirect_to url_for(:action => 'settings', 'project_id' => @project.id)
  end

  private

  def current_trf1_sjap_project
    record = Trf1SjapProject.find_by_project_id(@project.id)
    record = Trf1SjapProject.new if record.nil?
    record.project_id = @project.id
    record
  end
end
