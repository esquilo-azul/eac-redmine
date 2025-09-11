# frozen_string_literal: true

module Avm
  module Launcher
    module Paths
      class Real < String
        def initialize(path)
          raise "Argument path is not a string: \"#{path}\"|#{path.class}" unless path.is_a?(String)

          super
        end

        def subpath(relative_path)
          ::Avm::Launcher::Paths::Real.new(::File.expand_path(relative_path, self))
        end

        def basename
          ::File.basename(self)
        end

        def dirname
          return nil if self == '/'

          self.class.new(::File.dirname(self))
        end

        def find_file_with_extension(extension)
          r = find_files_with_extension(extension)
          return r.first if r.any?

          raise "Extension \"#{extension}\" not found in directory \"#{self}\""
        end

        def find_files_with_extension(extension)
          r = []
          ::Dir.entries(self).each do |i|
            r << ::File.expand_path(i, self) if i =~ /#{::Regexp.quote(extension)}\z/
          end
          r
        end
      end
    end
  end
end
