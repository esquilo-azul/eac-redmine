# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Generalização de threads com loop infinito.
    class  LoopThread < Thread
      def initialize(esosti_project_sync)
        @esosti_project_replicate = esosti_project_sync
        super { run_loop }
      end

      def run
        raise 'Método abstrato, sobreescreva-o.'
      end

      private

      def run_loop
        continue = true
        while (continue)
          if Rails.env.development?
            continue = run_step
          else
            begin
              continue = run_step
            rescue RuntimeError, Exception => ex
              log(:warn, ex.class.name + ': ' + ex.message)
              sleep_long
            end
          end
        end
      end
      
      def run_step
        begin
          return !(run() === true)
        rescue SocketError, HTTPClient::BadResponseError, ActiveRecord::ConnectionTimeoutError => ex
          log(:warn, ex.class.name + ': ' + ex.message)
          sleep_long
          return true
        end
      end

      def run_database_operation
        ActiveRecord::Base.connection_pool.with_connection do
          yield
        end
      end

      def log(method, message)
        @esosti_project_replicate.logger.send(method, Time.now.strftime('%d/%m/%y %H:%I:%S') + "|" + @esosti_project_replicate.trf1_sjap_project.project.identifier + "|" + to_s + ": " + message)
      end

      def to_s
        return self.class.name
      end
      
      def sleep_short
        random_sleep(1)
      end
      
      def sleep_long
        random_sleep(5)      
      end
      
      def random_sleep(seconds)
        sleep(seconds + rand(seconds + 1))        
      end

    end
  end
end
