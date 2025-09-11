# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        class VersionBuilder
          enable_simple_cache
          common_constructor :gem_name, :options

          def to_s
            r = "'~> #{two_segments}'"
            r += ", '>= #{three_segments}'" if segments.count >= 3 && segments[2].positive?
            r
          end

          # @return [Gem::Version]
          def version
            options_version || loaded_version || maximum_version
          end

          def two_segments
            segments.first(2).join('.')
          end

          def three_segments
            segments.first(3).join('.')
          end

          private

          # @return [Gem::Version]
          def maximum_version
            r = ::Avm::EacRubyBase1::Rubygems::Remote.new(gem_name).maximum_number
            return ::Gem::Version.new(r) if r.present?

            raise "None version found for gem \"#{gem_name}\""
          end

          def segments_uncached
            version.release.to_s.split('.').map(&:to_i)
          end

          # @return [Gem::Version, nil]
          def loaded_version
            ::Gem.loaded_specs[gem_name].if_present(&:version)
          end

          def options_version
            options["#{gem_name}_version".dasherize.to_sym].if_present do |v|
              ::Gem::Version.new(v)
            end
          end
        end
      end
    end
  end
end
