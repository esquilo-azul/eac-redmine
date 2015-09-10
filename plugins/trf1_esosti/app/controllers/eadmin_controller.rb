class EadminController < ApplicationController
  layout 'base'
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
end
