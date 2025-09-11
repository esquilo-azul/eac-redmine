# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class LineFactory
          TYPES = [GemConflict, InGemfile, DependsOn, RubyRequirement, VersionRequirement].freeze

          enable_simple_cache
          common_constructor :content do
            self.content = content.strip
          end

          delegate :blank?, to: :content

          private

          def result_uncached
            TYPES.lazy.map { |type| type.parse(content) }.find(&:present?)
          end
        end
      end
    end
  end
end
