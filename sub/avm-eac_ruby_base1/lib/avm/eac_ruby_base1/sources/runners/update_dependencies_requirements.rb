# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class UpdateDependenciesRequirements
          runner_with :help do
            bool_opt '-a', '--all'
            arg_opt '-e', '--exclude', repeat: true
            pos_arg :gem_name, repeat: true, optional: true
          end

          def run
            start_banner
            update_gemfile_lock
            process_all_gems
          end

          def gemspec
            ::Avm::EacRubyBase1::Rubygems::Gemspec.from_file(
              runner_context.call(:source).gemspec_path
            )
          end

          private

          def exclude?(gem_name)
            parsed.exclude.include?(gem_name)
          end

          def gem_names_uncached
            ::Set.new(parsed.gem_name + gem_names_from_all).reject { |gem_name| exclude?(gem_name) }
              .sort
          end

          def gem_names_from_all
            return [] unless parsed.all?

            gemspec.dependencies.map(&:gem_name)
          end

          def process_all_gems
            gem_names.each do |gem_name|
              infov 'Gem to update', gem_name
              ::Avm::EacRubyBase1::Sources::UpdateDependencyRequirements
                .new(runner_context.call(:source), gem_name).perform
            end
          end

          def start_banner
            runner_context.call(:source_banner)
            infov 'Gems to update', gem_names.count
          end

          def update_gemfile_lock
            infom 'Updating Gemfile\'s lock...'
            runner_context.call(:source).bundle('update').execute!
          end
        end
      end
    end
  end
end
