# frozen_string_literal: true

module Avm
  module Sources
    module Tests
      class Single
        MAIN_SOURCE_ID = '#main'

        compare_by :order_group, :id
        enable_simple_cache
        enable_speaker

        common_constructor :builder, :source, :test_name, :test_command

        delegate :to_s, to: :id

        def failed?
          result == ::Avm::Sources::Tests::Result::FAILED
        end

        # @return [String]
        def id
          "#{main? ? MAIN_SOURCE_ID : relative_path_from_main_source}##{test_name}"
        end

        def main?
          relative_path_from_main_source.to_s == '.'
        end

        def order_group
          main? ? 1 : 0
        end

        # @return [Pathname]
        def relative_path_from_main_source
          source.path.relative_path_from(builder.main_source.path)
        end

        private

        # @return [EacFs::Logs]
        def logs_uncached
          ::EacFs::Logs.new.add(:stdout).add(:stderr)
        end

        # @return [Avm::Sources::Tests::Result]
        def result_uncached
          if test_command.blank?
            ::Avm::Sources::Tests::Result::NONEXISTENT
          elsif run_test_command
            ::Avm::Sources::Tests::Result::SUCESSFUL
          else
            ::Avm::Sources::Tests::Result::FAILED
          end
        end

        def run_test_command
          execute_command_and_log(test_command)
        end

        # @return [true, false]
        def execute_command_and_log(command) # rubocop:disable Naming/PredicateMethod
          r = command.execute
          logs[:stdout].write(r[:stdout])
          logs[:stderr].write(r[:stderr])
          r[:exit_code].zero?
        end
      end
    end
  end
end
