# frozen_string_literal: true

module Avm
  module ApplicationStereotypes
    class Base
      enable_listable
      lists.add_symbol :resource, :instance, :source, :source_generator
      common_constructor :namespace_module, :resources do
        self.resources = self.class.lists.resource.hash_keys_validate!(resources)
      end

      # @return [String]
      def name
        namespace_module.name.demodulize
      end

      # @return [String]
      def to_s
        name
      end

      lists.resource.each_value do |resource|
        define_method "#{resource}_class" do
          resources[resource]
        end
      end
    end
  end
end
