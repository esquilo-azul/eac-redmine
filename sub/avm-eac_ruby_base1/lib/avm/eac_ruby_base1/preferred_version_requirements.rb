# frozen_string_literal: true

module Avm
  module EacRubyBase1
    class PreferredVersionRequirements
      enable_simple_cache
      common_constructor :version do
        self.version = ::Avm::VersionNumber.new(version)
      end

      # @return [Avm::VersionNumber]
      def prefix_version
        ::Avm::VersionNumber.new(
          normalized_version.segments[0..(normalized_version.segments.count - 2)]
        )
      end

      # @return [Gem::Requirement]
      def to_requirement
        r = ["~> #{prefix_version}"]
        r << ">= #{normalized_version}" unless normalized_version.segments[-1].zero?
        ::Gem::Requirement.new(r)
      end

      # @return [Array<String>]
      def to_requirements_list
        to_requirement.requirements.map { |r| "#{r[0]} #{r[1]}" }
      end

      private

      # @return [Avm::VersionNumber]
      def normalized_version_uncached
        r = version
        r = ::Avm::VersionNumber.new(r.segments + [0]) while r.segments.count < 3
        r
      end
    end
  end
end
