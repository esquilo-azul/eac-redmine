# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rspec
      module Setup
        def self.extended(obj)
          obj.rspec_config.include(::Avm::EacRubyBase1::Rspec::SourceGenerator)
        end
      end
    end
  end
end
