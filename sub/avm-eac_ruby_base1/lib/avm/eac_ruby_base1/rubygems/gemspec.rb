# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class Gemspec
        require_sub __FILE__, require_mode: :kernel
        enable_simple_cache

        DEPENDENCY_LINE_PARSER = /s\.add([a-zA-Z0-9_]*)_dependency\s*'(\S+)'/
                                   .to_parser { |m| [m[2], m[1]] }

        class << self
          def from_file(path)
            new(path.read.each_line.map(&:rstrip))
          end
        end

        common_constructor :lines

        # @param gem_name [String]
        # @return [Avm::EacRubyBase1::Bundler::Gemfile::Dependency]
        def dependency(gem_name)
          dependencies_hash.fetch(gem_name)
        end

        # @return [Array<Avm::EacRubyBase1::Bundler::Gemfile::Dependency>]
        def dependencies
          dependencies_hash.values
        end

        def write(path)
          path.to_pathname.write(to_text)
        end

        def to_text
          lines.map { |line| "#{line}\n" }.join
        end

        protected

        # @param gem_name [String]
        # @param type [String] Avm::EacRubyBase1::Rubygems::Gemspec::Dependency::TYPE_*
        # @return [Avm::EacRubyBase1::Bundler::Gemfile::Dependency]
        def create_dependency(gem_name, type)
          ::Avm::EacRubyBase1::Rubygems::Gemspec::Dependency.new(self, gem_name, type)
        end

        # @return [Hash<String, Avm::EacRubyBase1::Bundler::Gemfile::Dependency>]
        def dependencies_hash_uncached
          lines.lazy.map { |line| DEPENDENCY_LINE_PARSER.parse(line) }.compact_blank
            .map { |dependency_args| create_dependency(*dependency_args) }.index_by(&:gem_name)
        end
      end
    end
  end
end
