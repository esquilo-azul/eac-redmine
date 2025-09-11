# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Files
    class TextReplacer
      require_sub __FILE__
      enable_immutable

      immutable_accessor :replacement, type: :array

      def apply(input)
        replacements.inject(input) { |a, e| e.apply(a) }
      end

      def file_apply(file) # rubocop:disable Naming/PredicateMethod
        file = file.to_pathname
        input = file.read
        output = apply(file.read)
        return false if output == input

        file.write(output)
        true
      end

      def gsub(from, to)
        replacement(::Avm::Files::TextReplacer::Gsub.new(from, to))
      end
    end
  end
end
