# frozen_string_literal: true

module Avm
  module Instances
    class Base
      module EntryKeys
        # @return [Enumerable<String>]
        def entry_keys
          ::Avm::Instances::EntryKeys.all
        end

        ::Avm::Instances::EntryKeys.all.each do |key|
          method_name = key.to_s.variableize
          define_method method_name do
            read_entry(key)
          end

          define_method "#{method_name}_optional" do
            read_entry_optional(key)
          end
        end
      end
    end
  end
end
