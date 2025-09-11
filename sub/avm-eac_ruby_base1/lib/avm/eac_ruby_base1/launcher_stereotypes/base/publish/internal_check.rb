# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        class Publish < ::Avm::Launcher::Publish::Base
          class InternalCheck
            acts_as_instance_method

            common_constructor :publish
            delegate :gem_provider, :gem_published?, :gem_spec, :gem_version_max,
                     :outdated_version?, :version_published?, to: :publish

            def result
              gem_published? ? internal_check_gem_published : internal_check_gem_unpublished
            end

            protected

            def internal_check_gem_published
              if version_published?
                outdated_version? ? outdated_version_check_result : version_published_check_result
              else
                version_unpublished_check_result
              end
            end

            def internal_check_gem_unpublished
              if new_gem_allowed?
                version_unpublished_check_result
              else
                new_gem_disallowed_check_result
              end
            end

            def new_gem_allowed?
              ::Avm::Launcher::Context.current.publish_options[:new]
            end

            def new_gem_disallowed_check_result
              ::Avm::Launcher::Publish::CheckResult.blocked(
                publish.i18n_translate(__method__, gem: gem_spec.full_name, provider: gem_provider)
              )
            end

            def version_published_check_result
              ::Avm::Launcher::Publish::CheckResult.updated(
                publish.i18n_translate(__method__, gem: gem_spec.full_name)
              )
            end

            def outdated_version_check_result
              ::Avm::Launcher::Publish::CheckResult.outdated(
                publish.i18n_translate(__method__, gem: gem_spec.full_name,
                                                   max_version: gem_version_max)
              )
            end

            def version_unpublished_check_result
              ::Avm::Launcher::Publish::CheckResult.pending(
                publish.i18n_translate(__method__, gem: gem_spec.name, provider: gem_provider)
              )
            end
          end
        end
      end
    end
  end
end
