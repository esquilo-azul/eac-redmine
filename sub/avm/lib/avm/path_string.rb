# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module Avm
  # String with paths like PATH variable.
  # Note: the separator is not system dependent.
  class PathString < String
    SEPARATOR = ':'

    class << self
      # Shortcut for [Avm::Paths.new(string).paths].
      def paths(string)
        new(string).paths
      end
    end

    def initialize(string = nil)
      super(string.to_s)
    end

    # @return [Array] List of paths. Blank paths are rejected.
    def paths
      split(SEPARATOR).compact_blank
    end
  end
end
