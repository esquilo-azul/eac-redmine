# frozen_string_literal: true

module Avm
  module Scms
    class CommitInfo
      class << self
        # @param source [Avm::Scms::CommitInfo, String]
        # @return [Avm::Scms::CommitInfo]
        def assert(source)
          return source if source.is_a?(self)
          return new if source.nil?
          return new.message(source) if source.is_a?(::String)
          return assert(source.call) if source.is_a?(::Proc)

          raise "Unmapped assertion for #{source.to_debug}"
        end
      end

      enable_immutable

      immutable_accessor :fixup, :message
      immutable_accessor :path, type: :array

      def to_s
        "#{self.class.name.demodulize}[#{attributes_to_s}]"
      end

      private

      # @return [String]
      def attributes_to_s
        %w[fixup message].map { |m| [m, send(m)] }.reject { |m| m[1].blank? }
          .map { |m| m.join(': ') }.join(',')
      end
    end
  end
end
