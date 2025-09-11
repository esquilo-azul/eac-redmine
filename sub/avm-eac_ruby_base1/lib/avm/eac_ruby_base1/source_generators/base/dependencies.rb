# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module Dependencies
          common_concern

          COMMON_DEPENDENCY_GEMS = %w[eac_ruby_utils].freeze
          DEVELOPMENT_DEPENDENCY_GEMS = %w[eac_ruby_gem_support].freeze

          module ClassMethods
            # @return [Array<String>]
            def common_dependency_gems
              COMMON_DEPENDENCY_GEMS
            end

            # @return [Array<String>]
            def development_dependency_gems
              DEVELOPMENT_DEPENDENCY_GEMS
            end
          end

          # @return [String]
          def common_dependencies
            dependencies_section(:common_dependency_gems, '')
          end

          def dependency_version(gem_name)
            ::Avm::EacRubyBase1::SourceGenerators::Base::VersionBuilder.new(gem_name, options).to_s
          end

          # @return [String]
          def development_dependencies
            dependencies_section(:development_dependency_gems, 'development_')
          end

          protected

          # @param gem_name [String]
          # @param prefix [String]
          # @return [String]
          def dependency_line(gem_name, prefix)
            "#{IDENT}s.add_#{prefix}dependency '#{gem_name}', #{dependency_version(gem_name)}\n"
          end

          # @param setting_key [Symbol]
          # @param prefix [String]
          # @return [String]
          def dependencies_section(gems_method, prefix)
            self.class.send(gems_method).sort.map { |gem_name| dependency_line(gem_name, prefix) }
              .join.rstrip
          end
        end
      end
    end
  end
end
