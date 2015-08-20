# encoding: UTF-8

require 'nokogiri'
require 'unicode_utils/titlecase'

module Trf1Sjap
  class EsostiProjectReplicate < Thread
    attr_reader :session, :trf1_sjap_project, :login_control
    def initialize trf1_sjap_project, continue_callback
      @trf1_sjap_project = trf1_sjap_project
      @continue_callback = continue_callback
      @session = @trf1_sjap_project.create_eadmin_http_session
      @solicitacoes_thread = nil
      @login_thread = nil
      @caixa_secao_atendimento_thread = nil     
      @login_control = LoginControl.new(self)
      super { run }
    end

    def logger
      Rails.logger
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