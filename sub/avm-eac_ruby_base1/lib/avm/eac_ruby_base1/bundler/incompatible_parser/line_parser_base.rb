# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class LineParserBase
          class << self
            def parse(line_content)
              const_get('LINE_PARSER').parse(line_content)
            end
          end
        end
      end
    end
  end
end
