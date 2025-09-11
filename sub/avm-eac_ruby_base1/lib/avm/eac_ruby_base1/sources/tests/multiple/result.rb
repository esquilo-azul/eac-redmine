# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Tests
        class Multiple
          class Result
            common_constructor :result

            COLORS = {
              ::Avm::EacRubyBase1::Sources::Tests::Base::RESULT_FAILED => :red,
              ::Avm::EacRubyBase1::Sources::Tests::Base::RESULT_NONEXISTENT => :white,
              ::Avm::EacRubyBase1::Sources::Tests::Base::RESULT_SUCCESSFUL => :green
            }.freeze

            def tag
              result.to_s.send(color)
            end

            def color
              COLORS.fetch(result)
            end
          end
        end
      end
    end
  end
end
