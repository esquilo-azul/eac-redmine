# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class DependsOn < ::Avm::EacRubyBase1::Bundler::IncompatibleParser::LineParserBase
          LINE_PARSER = /(.+) was resolved to (.+), which depends on/
                          .to_parser { |m| new(m[1], m[2]) }

          common_constructor :gem_name, :version do
            self.version = ::Gem::Version.new(version)
          end

          def data
            { gem_name: gem_name, version: version }
          end
        end
      end
    end
  end
end
