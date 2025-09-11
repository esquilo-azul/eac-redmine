# frozen_string_literal: true

module Avm
  module Data
    class Package
      module BuildDirectory
        private

        attr_writer :build_directory

        # @return [EacRubyUtils::Fs::Temp::Directory]
        def build_directory
          @build_directory || raise('@build_directory is blank')
        end

        def on_build_directory
          ::EacRubyUtils::Fs::Temp.on_directory do |directory|
            self.build_directory = directory
            yield
          end
        end
      end
    end
  end
end
