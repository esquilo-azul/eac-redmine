class EadminController < ApplicationController
  layout 'base'

  helper :sort
  include SortHelper
  def esosti_alerta
    request.params[:banco] = 'JFAP'
  end

  def esosti_alerta_data
    session = Trf1Sjap::EadminHttpSession.new(
        request.params[:matricula],
        request.params[:senha],
        request.params[:banco]
      )
    @loginResult = session.login
    @solicitacoes = nil
    if @loginResult
      caixa = Trf1Sjap::CaixaAtendimentoSecao.new(session.caixaAtendimentoSecao)
      @solicitacoes = caixa.solicitacoesData
      @novaSolicitacao = caixa.novaSolicitacao?
    end
    render(:layout => false) if request.xhr?
  end

end
