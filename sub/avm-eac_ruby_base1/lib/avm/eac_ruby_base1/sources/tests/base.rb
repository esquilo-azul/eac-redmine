# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Tests
        class Base
          include ::EacRubyUtils::Listable

          enable_simple_cache
          lists.add_string :result, :failed, :nonexistent, :successful

          common_constructor :gem

          def elegible?
            dependency_present? && gem.root.join(test_directory).exist?
          end

          def dependency_present?
            gem.gemfile_path.exist? && gem.gemfile_lock_gem_version(dependency_gem).present?
          end

          def name
            self.class.name.demodulize.gsub(/Test\z/, '')
          end

          def to_s
            "#{gem}[#{name}]"
          end

          private

          def logs_uncached
            ::EacFs::Logs.new.add(:stdout).add(:stderr)
          end

          def result_uncached
            return RESULT_NONEXISTENT unless elegible?

            exec_run_with_log ? RESULT_SUCCESSFUL : RESULT_FAILED
          end

          def exec_run
            gem.bundle('exec', *bundle_exec_args).chdir_root.execute
          end

          def exec_run_with_log # rubocop:disable Naming/PredicateMethod
            r = exec_run
            logs[:stdout].write(r[:stdout])
            logs[:stderr].write(r[:stderr])
            r[:exit_code].zero?
          end
        end
      end
    end
  end
end
