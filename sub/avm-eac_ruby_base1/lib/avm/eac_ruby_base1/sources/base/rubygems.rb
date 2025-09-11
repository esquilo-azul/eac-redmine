# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Rubygems
          GEMSPEC_EXTNAME = '.gemspec'

          def gem_name
            gem_name_by_gemspec || gem_name_by_path
          end

          def gem_name_by_gemspec
            gemspec_path.if_present { |v| v.basename(GEMSPEC_EXTNAME).to_path }
          end

          def gem_name_by_path
            fullname = path.basename.to_s
            /\A(.+)(?:-\d+(?:\.\d+)*)\z/.if_match(fullname, false) { |m| m[1] }.if_present(fullname)
          end

          def gem_namespace_parts
            gem_name.split('-')
          end

          # @return [Gem::Specification]
          def gemspec
            ::Gem::Specification.load(gemspec_path.to_path)
          end

          # @return [Pathname]
          def gemspec_path
            path.glob("*#{GEMSPEC_EXTNAME}").first
          end

          # @return [Pathname]
          def root_module_directory
            path.join('lib', *gem_namespace_parts)
          end

          # @return [Pathname]
          def root_module_file
            root_module_directory.dirname.join("#{root_module_directory.basename}.rb")
          end
        end
      end
    end
  end
end
