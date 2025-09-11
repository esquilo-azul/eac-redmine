# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class UpdateDependencyRequirements
        enable_simple_cache
        common_constructor :source, :gem_name

        RUBOCOP_OK_CODES = [256].freeze

        def perform
          source.scm.commit_if_change(commit_message) { update_code }
        end

        private

        # @return [String]
        def commit_message
          i18n_translate(__method__,
                         name: gem_name,
                         requirements_list: requirements_list.join(', '),
                         __locale: source.locale)
        end

        def format_gemspec
          source.rubocop_command.ignore_parent_exclusion(true).autocorrect(true)
            .file(source.gemspec_path)
            .execute!(exit_outputs: RUBOCOP_OK_CODES.index_with { |_k| nil })
        end

        # @return [Array<String>]
        def requirements_list_uncached
          ::Avm::EacRubyBase1::PreferredVersionRequirements.new(
            source.gemfile_lock_gem_version(gem_name)
          ).to_requirements_list
        end

        def gemspec_uncached
          ::Avm::EacRubyBase1::Rubygems::Gemspec.from_file(source.gemspec_path)
        end

        def parent_bundle
          source.parent.if_present(&:on_sub_updated)
        end

        def update_code
          update_gemspec
          source.bundle.system!
          parent_bundle
        end

        def update_gemspec
          gemspec.dependency(gem_name).version_specs = requirements_list
          gemspec.write(source.gemspec_path)
          format_gemspec
        end
      end
    end
  end
end
