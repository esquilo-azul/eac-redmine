# encoding: UTF-8

module Trf1Sjap
  class EsostiProjectReplicate
    # Generalização de threads com loop infinito.
    class  LoopThread < Thread
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
          if Rails.env.development?
            continue = !(run() === true)
          else
            begin
              continue = !(run() === true)
            rescue RuntimeError, Exception => ex
              log(ex.class.name + ': ' + ex.message)
              sleep(SLEEP_INTERVAL)
            end
          end
        end
      end

      def run_database_operation
        run = true
        while(run)
          begin
            ActiveRecord::Base.connection_pool.with_connection do
              yield
            end
            run = false
          rescue ActiveRecord::ConnectionTimeoutError => ex
            log(ex.class.name + ': ' + ex.message)
            sleep(1)
          end
        end
      end

      def log(message)
        @esosti_project_sync.logger.info(@esosti_project_sync.trf1_sjap_project.project.identifier + "|" + to_s + ": " + message)
      end

      def to_s
        return self.class.name
      end

    end
  end
end
