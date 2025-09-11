# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Launcher
      module Gem
        class Specification
          class << self
            def parse_version_file(file)
              s = ::File.read(file)
              m = /VERSION\s*=\s*['"]([^'"]+)['"]/.match(s)
              m ? m[1] : nil
            end
          end

          attr_reader :gemspec_file

          def initialize(gemspec_file)
            @gemspec_file = gemspec_file
          end

          def version
            v = self.class.parse_version_file(version_file)
            return v if v.present?

            raise "Version not found on file \"#{version_file}\""
          end

          def name
            ::File.basename(gemspec_file).gsub(/\.gemspec\z/, '')
          end

          def full_name
            "#{name}-#{version}"
          end

          def to_s
            full_name
          end

          private

          def gem_root
            ::File.dirname(gemspec_file)
          end

          def version_file
            f = ::File.join(gem_root, 'lib', *namespace_parts, 'version.rb')
            return f if ::File.exist?(f)

            raise "Version file \"#{f}\" does not exist"
          end

          def namespace_parts
            name.split('-')
          end
        end
      end
    end
  end
end
