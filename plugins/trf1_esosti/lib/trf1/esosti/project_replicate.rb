require 'thread/pool'

module Trf1
  module Esosti
    class ProjectReplicate
      attr_reader :session, :trf1_sjap_project

      def initialize(trf1_sjap_project)
        @trf1_sjap_project = trf1_sjap_project
        @session_logged = false
      end

      def session
        @session ||= @trf1_sjap_project.create_eadmin_http_session
      end

      def update_tasks
        if session_login
          tasks = [caixa_task]
          tasks.concat(solicitacao_tasks)
          tasks
        else
          []
        end
      end

      private

      def caixa_task
        proc { CaixaAtendimentoUpdateTask.new(self).run }
      end

      def solicitacao_tasks
        solicitacoes_abertas.map do |s|
          proc { SolicitacaoUpdateTask.new(self, s).run }
        end
      end

      def solicitacoes_abertas
        EsostiSolicitacao.where(closed: false, trf1_sjap_project_id: @trf1_sjap_project.id)
      end

      def session_login
        Rails.logger.info 'Login e-Admin ' + @trf1_sjap_project.eadmin_matricula + '/' + @trf1_sjap_project.eadmin_banco
        login_result = session.login
        if login_result === true
          Rails.logger.info 'Login ok'
          true
        else
          Rails.logger.warn "Login falhou: #{login_result}"
          false
        end
      end
    end
  end
end
