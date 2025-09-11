# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        RSPEC_TEST_COMMAND = 'rspec'

        require_sub __FILE__, include_modules: :prepend

        # @return [Hash<String, EacRubyUtils::Envs::Command>]
        def default_test_commands
          {
            RSPEC_TEST_COMMAND => rspec_test_command
          }
        end

        # To-do: dismiss this method at Avm::EacRailsBase1::Instance and remove.
        # @return [EacRubyUtils::Envs::BaseEnv]
        def env
          @env.presence || super
        end

        # To-do: dismiss this method at Avm::EacRailsBase1::Instance and remove.
        # @return [Avm::EacRubyBase1::Sources::Base]
        def env_set(env)
          @env = env

          self
        end

        # @return [Avm::EacRubyBase1::Source::Base]
        def ruby_parent
          a_parent = parent

          loop do
            raise 'No Ruby parent found' if a_parent.blank?
            return a_parent if a_parent.is_a?(::Avm::EacRubyBase1::Sources::Base)

            a_parent = a_parent.parent
          end
        end

        # @return [EacRubyUtils::Envs::Command]
        def rspec_test_command
          bundle('exec', 'rspec', '--fail-fast').chdir_root
        end

        def valid?
          gemfile_path.exist? || gemspec_path.present?
        end
      end
    end
  end
end
