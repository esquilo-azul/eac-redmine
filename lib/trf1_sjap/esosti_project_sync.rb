# encoding: UTF-8

require 'nokogiri'
require 'unicode_utils/titlecase'

module Trf1Sjap
  class EsostiProjectSync < Thread
    def initialize trf1_sjap_project, continue_callback
      @trf1_sjap_project = trf1_sjap_project
      @continue_callback = continue_callback
      @session = Trf1Sjap::EadminHttpSession.new(
          @trf1_sjap_project.eadmin_matricula,
          @trf1_sjap_project.eadmin_senha,
          @trf1_sjap_project.eadmin_banco
          )
      @login_phase = true
      super { run }
    end

    private
    
    def run
      while(@continue_callback.call()) do
        run_step
        sleep 1
      end
    end

    def run_step
      if @login_phase
        Rails.logger.info "Login e-Admin " + @trf1_sjap_project.eadmin_matricula + "/" + @trf1_sjap_project.eadmin_banco
        loginResult = @session.login
        if loginResult === true
          Rails.logger.info "Login ok"
          @login_phase = false
        else
          Rails.logger.info "Login falhou: " + loginResult.to_s
        end
      else
        begin
          Rails.logger.info "Procurado solicitações em aberto"
          caixa_atendimento = @session.caixaAtendimentoSecao
          Rails.logger.info "Solicitações encontradas: " + caixa_atendimento.solicitacoes.length.to_s
          for solicitacao in caixa_atendimento.solicitacoes do
            @trf1_sjap_project.import_caixa_atendimento_secao_solicitacao solicitacao
          end
        rescue Exception => ex
          Rails.logger.info ex.to_s
          Rails.logger.info ex.backtrace
          @login_phase = true
        end
      end
    end

  end

end