# frozen_string_literal: true

module Avm
  module Registry
    class Sources < ::Avm::Registry::WithPath
      # @return [Avm::ApplicationStereotypes::Base]
      def application_stereotype_by_name(name)
        ::Avm::Registry.application_stereotypes.detect(name)
      end

      # @return [Avm::Sources::Base, nil]
      def detect_optional(*detect_args)
        detect_optional_by_configuration(*detect_args) ||
          detect_optional_by_application_configuration(*detect_args) ||
          super
      end

      # @return [Avm::Sources::Base, nil]
      def detect_optional_by_application_configuration(path, *detect_args)
        ::Avm::Sources::Base.new(path).application.stereotype_by_configuration.if_present do |v|
          v.source_class.new(path, *detect_args)
        end
      end

      # @return [Avm::Sources::Base, nil]
      def detect_optional_by_configuration(path, *detect_args)
        source_configured_stereotype_name(path).if_present do |v|
          application_stereotype_by_name(v).source_class.new(path, *detect_args)
        end
      end

      # @return [String]
      def source_configured_stereotype_name(path)
        ::Avm::Sources::Base.new(path).stereotype_name_by_configuration
      end
    end
  end
end
