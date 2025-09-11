# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module LauncherStereotypes
      class Base
        class Publish < ::Avm::Launcher::Publish::Base
          module RemoteGem
            def gem_provider
              instance.source.gem_provider
            end

            def gem_published?
              gem_versions.any?
            end

            def gem_version_max
              remote_gem.maximum_number
            end

            # @return [Array]
            def gem_versions
              remote_gem.versions
            end

            def outdated_version?
              gem_version_max.present? && ::Gem::Version.new(gem_spec.version) < gem_version_max
            end

            def version_published?
              gem_versions.any? { |v| v['number'] == gem_spec.version }
            end

            protected

            # @return [Avm::EacRubyBase1::Rubygems::Remote]
            def remote_gem_uncached
              ::Avm::EacRubyBase1::Rubygems::Remote.new(gem_spec.name, gem_provider)
            end
          end
        end
      end
    end
  end
end
