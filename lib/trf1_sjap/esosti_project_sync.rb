# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap
  class EsostiProjectSync
    def initialize trf1_sjap_project
      @trf1_sjap_project = trf1_sjap_project
      @session = Trf1Sjap::EadminHttpSession.new(
          @trf1_sjap_project.eadmin_matricula,
          @trf1_sjap_project.eadmin_senha,
          @trf1_sjap_project.eadmin_banco
          )
      @login_phase = true
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
          Rails.logger.info caixa_atendimento.solicitacoes.to_s
        rescue Exception => ex
          Rails.logger.info ex.to_s
          @login_phase = true
        end
      end
    end

  end

end