# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundle
          runner_with :help do
            desc 'Runs "bundle ...".'
            pos_arg :'bundle-args', repeat: true, optional: true
          end

          def run
            bundle_command.system!
          end

          def bundle_command
            runner_context.call(:source).bundle(*bundle_args)
          end

          delegate :bundle_args, to: :parsed
        end
      end
    end
  end
end
