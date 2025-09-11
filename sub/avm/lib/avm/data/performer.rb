# frozen_string_literal: true

module Avm
  module Data
    class Performer
      acts_as_abstract(:cannot_perform_reason, :internal_perform)
      acts_as_immutable
      common_constructor :data_owner
      immutable_accessor :exclude, :include, type: :set

      # @return [Enumerable]
      def immutable_constructor_args
        [data_owner]
      end

      # @return [self]
      def perform
        raise "Cannot run: #{cannot_perform_reason}" unless performable?

        internal_perform

        self
      end

      # @return [Boolean]
      def performable?
        cannot_perform_reason.blank?
      end

      protected

      def include_excludes_arguments
        options = include_excludes_options
        options.any? ? [options] : []
      end

      def include_excludes_options
        r = {}
        r[:includes] = includes if includes.any?
        r[:excludes] = excludes if excludes.any?
        r
      end
    end
  end
end
