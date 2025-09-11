# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundler
          class GemfileLocal
            runner_with :help do
              bool_opt '-w', '--write', 'Write the Gemfile.local file.'
            end
            delegate :siblings, to: :builder

            def run
              start_banner
              builder.run_bundle
              siblings_banner
              write_gemfile_local
            end

            private

            def start_banner
              runner_context.call(:source_banner)
              infov 'Parent', the_source.parent
            end

            def siblings_banner
              infov 'Siblings', siblings.count
              siblings.each do |sibling|
                infov '  * ', sibling.relative_path
              end
            end

            def write_gemfile_local
              return unless parsed.write?

              infom "Writing #{builder.target_path}..."
              builder.write_target_file
            end

            def the_source
              runner_context.call(:source)
            end

            # @return [Avm::EacRubyBase1::Sources::GemfileLocal]
            def builder_uncached
              ::Avm::EacRubyBase1::Sources::GemfileLocal.new(the_source)
            end
          end
        end
      end
    end
  end
end
