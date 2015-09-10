# encoding: UTF-8

module Trf1
  module Esosti
    class ProjectReplicate
      # Generalização de threads com loop infinito.
      class UpdateTask
        def initialize(project_replicate)
          @project_replicate = project_replicate
        end

        def log(method, message)
          Rails.logger.send(method, @project_replicate.trf1_sjap_project.project.identifier + '|' + to_s + ': ' + message)
        end

        def to_s
          self.class.name
        end
      end
    end
  end
end
