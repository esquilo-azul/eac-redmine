# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module RootModule
          def root_module
            lib_path.camelize
          end

          def root_module_close
            root_module_components.count.times.map do |index|
              "#{IDENT * index}end"
            end.reverse.join("\n")
          end

          def root_module_inner_identation
            IDENT * root_module_components.count
          end

          def root_module_open
            root_module_components.each_with_index.map do |component, index|
              "#{IDENT * index}module #{component}"
            end.join("\n")
          end

          def root_module_components
            root_module.split('::')
          end
        end
      end
    end
  end
end
