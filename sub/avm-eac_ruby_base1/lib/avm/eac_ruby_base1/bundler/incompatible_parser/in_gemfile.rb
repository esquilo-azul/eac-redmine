# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class InGemfile < ::Avm::EacRubyBase1::Bundler::IncompatibleParser::LineParserBase
          LINE_PARSER = /In Gemfile:/
                          .to_parser { |_m| new }
        end
      end
    end
  end
end
