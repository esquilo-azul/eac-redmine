# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class VersionFile
        common_constructor :path

        VERSION_LINE_PATTERN = /\A(\s*)VERSION\s*=\s*['"]([^'"]+)['"](\s*)\z/.freeze

        def value
          return nil unless path.file?

          path.read.each_line.lazy.map { |line| line_value(line) }.find { |v| v }
        end

        def value=(new_value)
          path.write(new_value_content(new_value))
        end

        private

        # @return Version found in line, nil otherwise.
        def line_value(line)
          VERSION_LINE_PATTERN.if_match(line.rstrip, false) { |m| ::Gem::Version.new(m[2]) }
        end

        def new_value_content(new_value)
          path.read.each_line
            .map { |line| new_value_line(line, new_value) }
            .join
        end

        def new_value_line(line, new_value)
          m = VERSION_LINE_PATTERN.match(line)
          return line unless m

          "#{m[1]}VERSION = '#{new_value}'#{m[3]}"
        end
      end
    end
  end
end
