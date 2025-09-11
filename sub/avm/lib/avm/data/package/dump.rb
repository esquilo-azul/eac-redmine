# frozen_string_literal: true

require 'minitar'

module Avm
  module Data
    class Package
      class Dump < ::Avm::Data::Package::BasePerformer
        enable_method_class
        include ::Avm::Data::Package::BuildDirectory

        attr_reader :target_path

        def initialize(package, target_path, options = {})
          super(package, options)
          @target_path = target_path.to_pathname
        end

        # @return [void]
        def result
          on_build_directory do
            dump_units_to_build_directory
            create_package_file
          end
        end

        protected

        def dump_units_to_build_directory
          package.dump_units_to_directory(build_directory, selected_units)
        end

        def create_package_file
          infom "Creating package \"#{target_path}\" from \"#{build_directory}\"..."
          ::Dir.chdir(build_directory.to_path) do
            ::Minitar.pack('.', ::File.open(target_path, 'wb'))
          end
        end
      end
    end
  end
end
