# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class Gemfile
        require_sub __FILE__, require_mode: :kernel

        class << self
          def from_file(path)
            new(path.read.each_line.map(&:rstrip))
          end
        end

        common_constructor :lines

        # @return [Avm::EacRubyBase1::Bundler::Gemfile::Dependency]
        def dependency(gem_name)
          ::Avm::EacRubyBase1::Bundler::Gemfile::Dependency.new(self, gem_name)
        end

        def write(path)
          path.to_pathname.write(to_text)
        end

        def to_text
          lines.map { |line| "#{line}\n" }.join
        end
      end
    end
  end
end
