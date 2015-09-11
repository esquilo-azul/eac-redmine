class EadminController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project_by_project_id, :authorize
  before_filter :find_trf1_sjap_project, only: [:eadmin_test_login, :settings]

  def esosti_alerta
    params[:banco] = 'JFAP'
    params[:intervalo] = 15
  end

  def esosti_alerta_data
    session = Trf1Sjap::EadminHttpSession.new(
      request.params[:matricula],
      request.params[:senha],
      request.params[:banco]
    )
    @loginResult = session.login
    @solicitacoes = nil
    if @loginResult === true
      @loginMessage = 'Ok'
      caixa = session.caixaAtendimentoSecao
      @solicitacoes = caixa.solicitacoes
      @novaSolicitacao = caixa.novaSolicitacao?
    else
      @loginMessage = @loginResult
      @loginResult = false
    end
    render(layout: false) if request.xhr?
  end

  def settings
    if request.patch? && @trf1_sjap_project.save
      flash[:notice] = l(:notice_trf1_sjap_project_saved)
      redirect_to url_for(:action => 'settings', 'project_id' => @project.id)
    end
    @projects_list = @project.children.map { |p| [p.name, p.id] }
  end

  def eadmin_test_login
    login_result = @trf1_sjap_project.create_eadmin_http_session.login
    if login_result == true
      flash[:notice] = 'Login ok'
    else
      flash[:error] = 'Login falhou com a seguinte mensagem "' + login_result + '"'
    end
    redirect_to url_for(:action => 'settings', 'project_id' => @project.id)
  end

  private

  def find_trf1_sjap_project
    @trf1_sjap_project = Trf1SjapProject.find_by_project_id(@project.id)
    @trf1_sjap_project = Trf1SjapProject.new if @trf1_sjap_project.nil?
    @trf1_sjap_project.project_id = @project.id
    if params.key?(:trf1_sjap_project)
      @trf1_sjap_project.attributes = trf1_sjap_project_params
    end
    @trf1_sjap_project
  end

  def trf1_sjap_project_params
    params.require(:trf1_sjap_project).permit(:eadmin_matricula, :eadmin_senha, :eadmin_banco,
                                              :esosti_export_project_id)
  end
end
