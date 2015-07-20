# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Lê continuamente a caixa de seção de atendimento do projeto.
    class LoginControl
      def initialize(esosti_project_replicate)
        @esosti_project_replicate = esosti_project_replicate
        @loggedCv = ConditionVariable.new
        @notLoggedCv = ConditionVariable.new
        @mutex = Mutex.new
        @blocked = true
        @logged = false
      end

      def on_logged(&block)
        @mutex.synchronize do
          if ! @logged
            @loggedCv.wait(@mutex)
          end 
        end
        block.call
      end
      
      def on_not_logged(&block)
        @mutex.synchronize do
          if @logged
            @notLoggedCv.wait(@mutex)
          end 
        end
        block.call
      end

      def logged
        @mutex.synchronize do
          @logged = true
          @loggedCv.broadcast
        end
      end
      
      def not_logged
        @mutex.synchronize do          
          @logged = false
          @notLoggedCv.broadcast
        end
      end

    end
  end
end