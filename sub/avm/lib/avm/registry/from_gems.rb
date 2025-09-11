# frozen_string_literal: true

module Avm
  module Registry
    class FromGems < ::Avm::Registry::Base
      enable_abstract_methods
      enable_simple_cache

      def available
        registered_modules.reject(&:abstract?)
      end

      def class_detect(_klass, _detect_args)
        raise_abstract_method __method__
      end

      def detect(*registered_initialize_args)
        detect_optional(*registered_initialize_args) ||
          raise_not_found(*registered_initialize_args)
      end

      def detect_optional(*registered_initialize_args)
        available.reverse.lazy
          .map { |klass| class_detect(klass, registered_initialize_args) }.find(&:present?)
      end

      def provider_module_suffix
        "#{module_suffix}::Provider"
      end

      def single_module_suffix
        "#{module_suffix}::Base"
      end

      def valid_registered_module?(a_module)
        a_module.is_a?(::Class) && !a_module.abstract?
      end

      private

      def registered_modules_uncached
        registered_gems.flat_map { |registry| modules_from_registry(registry) }
          .select { |v| valid_registered_module?(v) }.uniq
      end

      def modules_from_registry(registry)
        if registry.registry.module_suffix == provider_module_suffix
          registry.registered_module.new.all
        else
          [registry.registered_module]
        end
      end

      def registered_gems
        (single_instance_registry.registered + provider_registry.registered).sort
      end

      def single_instance_registry_uncached
        ::EacRubyUtils::GemsRegistry.new(single_module_suffix)
      end

      def provider_registry_uncached
        ::EacRubyUtils::GemsRegistry.new(provider_module_suffix)
      end
    end
  end
end
