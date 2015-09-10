require 'thread/pool'

module Trf1
  module Esosti
    class SyncDaemon
      def self.run
        $running = true
        Signal.trap('TERM') do
          $running = false
        end

        Thread.abort_on_exception = true

        while $running
          run_threads
          sleep(5)
        end
      end

      def self.run_threads
        pool = Thread.pool(8)
        pool.process { SolicitacoesImport.run_all }
        for trf1_sjap_project in Trf1SjapProject.all
          Rails.logger.debug "Adicionando tarefas de atualização para #{trf1_sjap_project}"
          update_tasks = ProjectReplicate.new(trf1_sjap_project).update_tasks
          Rails.logger.debug "Tarefas de atualização encontradas: #{update_tasks.count}"
          update_tasks.each do |proc|
            pool.process do
              begin
                proc.call
              rescue Exception => ex
                Rails.logger.warn ex.class.to_s
                Rails.logger.warn ex
              end
            end
          end
        end
        pool.shutdown
      end
    end
  end
end
