# frozen_string_literal: true

module Avm
  module Registry
    require_sub __FILE__
    enable_listable
    lists.add_symbol :category, :applications, :application_scms, :application_stereotypes,
                     :config_objects, :file_formats, :instances, :launcher_stereotypes, :runners,
                     :scms, :source_generators, :sources

    class << self
      enable_simple_cache

      # @return [Array<Avm::Registry::FromGems>]
      def registries
        lists.category.values.map { |c| send(c) }
      end

      private

      ::Avm::Registry.lists.category.each_value do |category|
        define_method "#{category}_uncached" do
          registry_class(category).new(category.to_s.camelize)
        end
      end

      def registry_class(category)
        ::Avm::Registry.const_get(category.to_s.camelize)
      end
    end
  end
end
