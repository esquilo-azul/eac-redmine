# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Mantém uma sessão logada no e-Admin.
    class LoginThread < LoopThread
      def run
        @esosti_project_replicate.login_control.on_not_logged do
          log :info, 'Login e-Admin ' + @esosti_project_replicate.trf1_sjap_project.eadmin_matricula + '/' + @esosti_project_replicate.trf1_sjap_project.eadmin_banco
          loginResult = @esosti_project_replicate.session.login
          if loginResult === true
            log :info, 'Login ok'
            @esosti_project_replicate.login_control.logged
          else
            log :warn, 'Login falhou: ' + loginResult.to_s
            sleep_short
          end
        end
      end

      def to_s
        'LOGIN'
      end
    end
  end
end
