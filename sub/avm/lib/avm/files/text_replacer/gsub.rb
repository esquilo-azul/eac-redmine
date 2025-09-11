# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Files
    class TextReplacer
      class Gsub
        common_constructor :from, :to do
          self.from = from
          self.to = to
        end

        def apply(input)
          input.gsub(from, to)
        end

        def to_s
          "\"#{from}\" => \"#{to}\""
        end
      end
    end
  end
end
