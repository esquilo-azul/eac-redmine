# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class Remote
        enable_simple_cache
        common_constructor :name, :provider, default: [nil] do
          self.provider ||= ::Avm::EacRubyBase1::Rubygems::Providers::RubygemsOrg.new
        end

        # @return [Gem::Version, nil]
        def maximum_number
          numbers.max.if_present { |v| ::Gem::Version.new(v) }
        end

        # @return [Array<Gem::Version>]
        def numbers
          versions.map { |v| ::Gem::Version.new(v.fetch('number')) }
        end

        protected

        # @return [Array<String>]
        def versions_uncached
          provider.gem_versions(name)
        end
      end
    end
  end
end
