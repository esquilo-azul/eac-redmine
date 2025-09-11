# frozen_string_literal: true

require 'eac_cli/core_ext'

module Avm
  module Entries
    module Jobs
      module Base
        common_concern do
          include ::ActiveSupport::Callbacks
          include ::Avm::Entries::Jobs::WithVariablesSource

          enable_speaker
          enable_simple_cache
          enable_listable
          common_constructor :instance, :options, default: [{}] do
            if option_list.present?
              self.options = option_list.hash_keys_validate!(options.symbolize_keys)
            end
          end
          define_callbacks(*jobs)
        end

        module ClassMethods
          def jobs
            const_get('JOBS').dup
          end
        end

        module InstanceMethods
          def option_list
            nil
          end

          def run
            start_banner if respond_to?(:start_banner)
            run_jobs
            ::Avm::Result.success('Done!')
          rescue ::Avm::Result::Error => e
            e.to_result
          end

          protected

          def run_jobs
            jobs.each do |job|
              run_callbacks job do
                send(job)
              end
            end
          end

          def jobs
            self.class.jobs
          end
        end
      end
    end
  end
end
