# encoding: UTF-8

require 'nokogiri'
require 'unicode_utils/titlecase'

module Trf1Sjap
  class EsostiProjectReplicate < Thread
    SLEEP_INTERVAL = 5
    attr_reader :session, :trf1_sjap_project
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
      @signal_mutex = Mutex.new 
      super { run }
    end

    def logger
      #@@my_logger ||= Logger.new("#{Rails.root}/log/esosti_project_sync.log")
      @@my_logger ||= Logger.new(STDOUT)
    end
    
    def not_logged_signal
      @signal_mutex.synchronize {
        @login_thread.wakeup() if @login_thread != nil
      }
    end
    
    def logged_signal
      @signal_mutex.synchronize {
        @caixa_secao_atendimento_thread.wakeup() if @caixa_secao_atendimento_thread != nil 
        @solicitacoes_thread.wakeup_solicitacoes_threads() if @solicitacoes_thread != nil
      }
    end

    private

    def run
      while(@continue_callback.call()) do
        @login_thread = check_thread(@login_thread, LoginThread)
        @caixa_secao_atendimento_thread = check_thread(@caixa_secao_atendimento_thread, CaixaAtendimentoSecaoThread)
        @solicitacoes_thread = check_thread(@solicitacoes_thread, SolicitacoesThread)
        sleep(SLEEP_INTERVAL)
      end
    end   

    def check_thread(thread_variable, thread_class)
      if thread_variable == nil || thread_variable.status === nil || thread_variable.status === false
        thread_variable = thread_class.new(self)
      end
      return thread_variable
    end

    # Generalização de threads com loop infinito.
    class LoopThread < Thread
      def initialize(esosti_project_sync)
        @esosti_project_sync = esosti_project_sync
        super { run_loop }
      end

      def run
        raise 'Método abstrato, sobreescreva-o.'
      end

      private

      def run_loop
        continue = true
        while (continue)
          continue = !(run() === true)
        end
      end
      
      def log(message)
        @esosti_project_sync.logger.info(@esosti_project_sync.trf1_sjap_project.project.identifier + "|" + to_s + ": " + message)
      end
      
      def to_s
        return self.class.name
      end

    end

    # Mantém uma sessão logada no e-Admin.
    class LoginThread < LoopThread
      def run        
        log "Login e-Admin " + @esosti_project_sync.trf1_sjap_project.eadmin_matricula + "/" + @esosti_project_sync.trf1_sjap_project.eadmin_banco
        loginResult = @esosti_project_sync.session.login
        if loginResult === true
          log "Login ok"
          @esosti_project_sync.logged_signal
          Thread.stop        
        else
          log "Login falhou: " + loginResult.to_s
          sleep(1)
        end
      end
      
      def to_s
        return 'LOGIN'
      end

    end

    # Lê continuamente a caixa de seção de atendimento do projeto.
    class CaixaAtendimentoSecaoThread < LoopThread
      def run
        begin
          log 'Buscando fonte...'          
          caixa_atendimento = @esosti_project_sync.session.caixaAtendimentoSecao          
          log "Solicitações encontradas: " + caixa_atendimento.solicitacoes.length.to_s
          novas = Trf1Sjap::EsostiRedmineImport.import_caixa_secao_atendimento(@esosti_project_sync.trf1_sjap_project, caixa_atendimento.solicitacoes)
          log "Novas solicitações: " + novas.to_s
          sleep(SLEEP_INTERVAL)
        rescue Trf1Sjap::EadminHttpSession::UserNotLogged => ex
          log 'Não logado. Sinalizando...'
          @esosti_project_sync.not_logged_signal()
          Thread.stop
        end
      end
      
      def to_s
        return 'CAIXA'
      end

    end

    # Mantém threads de monitoramento de solicitações e-Sosti
    class SolicitacoesThread < LoopThread

      def initialize(trf1_sjap_project)
        @solicitacoes_threads = {}
        super(trf1_sjap_project)
      end
      
      def run
        log 'Buscando solicitações e-Sosti abertas'
        solicitacoes_abertas = EsostiSolicitacao.where(:closed => false, :trf1_sjap_project_id => @esosti_project_sync.trf1_sjap_project.id)
        log 'Solicitações abertas: ' + solicitacoes_abertas.count.to_s
        for solicitacao in solicitacoes_abertas
          if ! @solicitacoes_threads.has_key?(solicitacao.id)
            log 'Solicitação ID=#{solicitacao.id} não possui thread. Criando'
            @solicitacoes_threads[solicitacao.id] = SolicitacaoThread.new(@esosti_project_sync, solicitacao)
          end
        end
        sleep(SLEEP_INTERVAL)
      end

      def to_s
        return 'SOLICITACOES'
      end
      
      def wakeup_solicitacoes_threads        
        @solicitacoes_threads.each do |key, value|         
           value.wakeup()
        end
      end

    end

    # Lê continuamente os detalhes de uma solicitação
    class SolicitacaoThread < LoopThread
      def initialize(esosti_project_sync, esosti_solicitacao)
        @esosti_solicitacao = esosti_solicitacao
        super(esosti_project_sync)
      end

      def run
        begin
          log("Buscando fonte...")
          solicitacao_detalhes = @esosti_project_sync.session.solicitacao_detalhes(@esosti_solicitacao.esosti_id)
          Trf1Sjap::EsostiRedmineImport.import_solicitacao_detalhes(@esosti_solicitacao, solicitacao_detalhes.updates())
          sleep(SLEEP_INTERVAL)
        rescue Trf1Sjap::EadminHttpSession::UserNotLogged => ex
          log('Não logado. Sinalizando...')
          @esosti_project_sync.not_logged_signal()
          Thread.stop
        end
      end
      
      def to_s
        return "SOLICITACAO(#{@esosti_solicitacao.esosti_id})"
      end
      
    end

  end

end