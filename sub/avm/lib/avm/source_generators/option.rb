# frozen_string_literal: true

module Avm
  module SourceGenerators
    class Option
      common_constructor :name, :description, default: [nil] do
        self.name = name.to_sym
      end
    end
  end
end
