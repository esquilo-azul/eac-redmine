# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
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
  end
end