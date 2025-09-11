# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        class BundleCommand < ::EacRubyUtils::Ruby::Command
          GEMFILE_PATH_ENVVAR = 'BUNDLE_GEMFILE'

          attr_reader :source

          def initialize(source, command_args, extra_options = {})
            @source = source
            super(command_args, extra_options.merge(host_env: source.env))
          end

          # Changes current directory to the source's directory.
          def chdir_root
            chdir(source.path)
          end

          def envvar_gemfile
            envvar(GEMFILE_PATH_ENVVAR, source.gemfile_path.to_path)
          end

          protected

          def duplicate(command, extra_options)
            self.class.new(source, command, extra_options)
          end
        end
      end
    end
  end
end
