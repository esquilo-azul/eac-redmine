# frozen_string_literal: true

module Avm
  module ApplicationScms
    class Base
      acts_as_abstract

      class << self
        # @return [String]
        def type_name
          name.gsub(/#{Regexp.quote('::ApplicationScms::Base')}$/, '').demodulize
        end
      end

      # !method initialize(application)
      # @param application [Avm::Application::Base]
      common_constructor :application
      delegate :type_name, to: :class

      # @param path [Pathname]
      # @return [Pathname]
      def assert_main_at(path) # rubocop:disable Lint/UnusedMethodArgument
        raise_abstract_method __method__
      end

      # @return [String]
      def to_s
        "#{type_name}[#{to_s_type_specific}]"
      end

      # @return [String]
      def to_s_type_specific
        ''
      end
    end
  end
end
