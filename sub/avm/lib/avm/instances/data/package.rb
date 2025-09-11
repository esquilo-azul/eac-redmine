# frozen_string_literal: true

module Avm
  module Instances
    module Data
      class Package < ::Avm::Data::Package
        attr_reader :instance

        def initialize(instance, options = {})
          @instance = instance
          super(options)
        end

        # @return [Pathname]
        def data_default_dump_path
          instance.data_default_dump_path.to_pathname
        end

        def load(...)
          instance.on_disabled_processes { super }
        end
      end
    end
  end
end
