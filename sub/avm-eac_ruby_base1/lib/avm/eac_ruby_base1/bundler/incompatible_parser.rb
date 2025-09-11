# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        require_sub __FILE__

        enable_simple_cache
        attr_reader :gems_in_conflict

        def initialize(path)
          @gems_in_conflict = ::Avm::EacRubyBase1::Bundler::IncompatibleParser::LineBuffer
                                .from_file(path).gems_in_conflict.freeze
        end

        def data
          gems_in_conflict.map(&:data)
        end
      end
    end
  end
end
