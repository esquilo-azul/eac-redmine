# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module FileFormats
      class Base < ::Avm::EacGenericBase0::FileFormats::Base
        class FileResourceName
          enable_method_class
          common_constructor :file_format, :path do
            self.path = path.to_pathname
          end

          LIBRARY_PATTERNS = [%r{lib/((?!.*/lib/).+)\.rb\z},
                              %r{app/[^/]+/(.+)\.rb\z}].freeze
          SPEC_PATTERNS = [%r{spec/[^/]+/(.+)_spec\.rb\z}].freeze

          # @param path [Pathname]
          # @return [Avm::FileFormats::FileWith]
          def result
            result_from_spec || result_from_library || result_from_superclass
          end

          private

          def result_from_library
            result_from_patterns(LIBRARY_PATTERNS) { |m| m[1].camelize }
          end

          def result_from_patterns(patterns, &block)
            file_format.result_from_patterns(patterns, path, &block)
          end

          def result_from_spec
            result_from_patterns(SPEC_PATTERNS) { |m| "RSpec.describe(#{m[1].camelize})" }
          end

          def result_from_superclass
            file_format.result_from_superclass(path)
          end
        end
      end
    end
  end
end
