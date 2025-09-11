# frozen_string_literal: true

require 'minitar'

module Avm
  module Data
    class Package
      class Load < ::Avm::Data::Package::BasePerformer
        enable_method_class
        enable_speaker
        include ::Avm::Data::Package::BuildDirectory

        attr_reader :source_path

        def initialize(package, source_path, options = {})
          super(package, options)
          @source_path = source_path.to_pathname
        end

        def result
          on_build_directory do
            extract_packages_to_build_directory
            package.load_units_from_directory(build_directory, selected_units)
          end
        end

        def extract_packages_to_build_directory
          ::Minitar.unpack(source_path.to_path, build_directory.to_path)
        end
      end
    end
  end
end
