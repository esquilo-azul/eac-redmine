# frozen_string_literal: true

module Avm
  module Entries
    module Jobs
      class VariablesSource
        class ReadEntry
          enable_method_class
          common_constructor :variables_source, :path, :options, default: [{}]
          delegate :instance, :job, to: :variables_source

          def result
            return result_from_job if result_from_job?
            return result_from_instance_method if result_from_instance_method?

            result_from_instance_entry
          end

          private

          def path_method_name
            path.gsub('.', '_').underscore
          end

          def result_from_instance_entry
            instance.read_entry(path, options)
          end

          def result_from_instance_method
            instance.send(path_method_name)
          end

          def result_from_instance_method?
            instance.respond_to?(path_method_name, true)
          end

          def result_from_job
            job.send(path_method_name)
          end

          def result_from_job?
            job.respond_to?(path_method_name, true)
          end
        end
      end
    end
  end
end
