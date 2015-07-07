# encoding: UTF-8

require 'nokogiri'
require 'unicode_utils/titlecase'

module Trf1Sjap
  class EsostiProjectReplicate < Thread
    attr_reader :session, :trf1_sjap_project, :login_control
    def initialize trf1_sjap_project, continue_callback
      @trf1_sjap_project = trf1_sjap_project
      @continue_callback = continue_callback
      @session = Trf1Sjap::EadminHttpSession.new(
          @trf1_sjap_project.eadmin_matricula,
          @trf1_sjap_project.eadmin_senha,
          @trf1_sjap_project.eadmin_banco
          )
      @solicitacoes_thread = nil
      @login_thread = nil
      @caixa_secao_atendimento_thread = nil     
      @login_control = LoginControl.new(self)
      super { run }
    end

    def logger
      if defined?(@@my_logger).nil?
        if Rails.env.production?
          @@my_logger = Logger.new("#{Rails.root}/log/esosti_project_sync.log")
          @@my_logger.level = Logger::INFO
        else
          @@my_logger = Logger.new(STDOUT)
          @@my_logger.level = Logger::DEBUG
        end
      end
      @@my_logger
    end

    private

    def run
      while(@continue_callback.call()) do
        @login_thread = check_thread(@login_thread, LoginThread)
        @caixa_secao_atendimento_thread = check_thread(@caixa_secao_atendimento_thread, CaixaAtendimentoSecaoThread)
        @solicitacoes_thread = check_thread(@solicitacoes_thread, SolicitacoesThread)
        @redmine_import_thread = check_thread(@redmine_import_thread, RedmineImportThread)
        sleep(5)
      end
    end   

    def check_thread(thread_variable, thread_class)
      if thread_variable == nil || thread_variable.status === nil || thread_variable.status === false
        thread_variable = thread_class.new(self)
      end
      return thread_variable
    end
  end

end