# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Tests
        class Multiple
          require_sub __FILE__
          enable_speaker
          enable_simple_cache
          common_constructor :gems, :options, default: [{}]
          set_callback :initialize, :after, :run

          def ok?
            failed_tests.none?
          end

          def only
            options[:only]
          end

          private

          def all_tests_uncached
            decorated_gems.flat_map(&:tests)
          end

          def clear_logs
            all_tests.each do |test|
              test.logs.remove_all
            end
          end

          def prepare_all_gems
            infom 'Preparing all gems...'
            decorated_gems.each(&:prepare)
          end

          def decorated_gems_uncached
            r = gems
            r = r.select { |gem| only.include?(gem.name) } if only.present?
            r.map { |gem| DecoratedGem.new(gem) }
          end

          def failed_tests_uncached
            all_tests.select do |r|
              r.result == ::Avm::EacRubyBase1::Sources::Tests::Base::RESULT_FAILED
            end
          end

          def final_results_banner
            if failed_tests.any?
              warn 'Some test did not pass:'
              failed_tests.each do |test|
                infov '  * Test', test
                info test.logs.truncate_all
              end
            else
              success 'All tests passed'
            end
          end

          def run
            start_banner
            prepare_all_gems
            test_all_gems
            final_results_banner
          ensure
            clear_logs
          end

          def start_banner
            infov 'Gems to test', decorated_gems.count
          end

          def test_all_gems
            infom 'Running tests...'
            all_tests.each do |test|
              infov test, Result.new(test.result).tag
            end
          end
        end
      end
    end
  end
end
