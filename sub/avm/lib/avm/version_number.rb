# frozen_string_literal: true

module Avm
  # A sequence of segments of integer versions (Ex.: 2, 1.0.1, 3.0.0.0.0).
  class VersionNumber
    include ::Comparable

    SEGMENT_SEPARATOR = '.'

    class << self
      def segments_from_mixed(segments)
        (segments.is_a?(::Enumerable) ? segments.to_a : segments.to_s.split(SEGMENT_SEPARATOR))
          .map(&:to_i)
      end
    end

    attr_reader :segments

    def initialize(segments)
      @segments = self.class.segments_from_mixed(segments).freeze
    end

    delegate :[], to: :segments

    def <=>(other)
      segments <=> other.segments
    end

    def to_s
      segments.join(SEGMENT_SEPARATOR)
    end

    # @return [Avm::Version]
    def increment_segment(segment_index)
      x = [segments.count, segment_index + 1].max.times.map do |index|
        value = index < segments.count ? segments[index] : 0
        next value if index < segment_index
        next value + 1 if index == segment_index

        0
      end
      self.class.new x
    end
  end
end
