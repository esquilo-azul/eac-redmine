# frozen_string_literal: true

module Avm
  module SourceGenerators
    class OptionList
      enable_immutable
      immutable_accessor :option, type: :array

      alias immutable_option option

      def option(*args)
        immutable_option(::Avm::SourceGenerators::Option.new(*args))
      end

      # @return [Hash<Symbol, String>]
      def validate(options_hash)
        options_hash.transform_keys { |k| validate_option(k) }
      end

      def validate_option(option_name)
        option_name = option_name.to_sym

        return option_name if options.any? { |option| option.name == option_name }

        raise "No option found with name \"#{option_name}\""
      end
    end
  end
end
