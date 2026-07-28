# frozen_string_literal: true

module EacRailsGemSupport
  module Rspec
    module MinitestSupport
      def assert_difference(code, message = nil, compare_method = :not_to, &block)
        before_value = assert_difference_call(code)
        block.call
        after_value = assert_difference_call(code)
        expect(after_value).send(compare_method, eq(before_value), message)
      end

      def assert_no_difference(code, message = nil, &)
        assert_difference(code, message, :to, &)
      end

      def assert_equal(expected_value, actual_value, message = nil)
        expect(actual_value).to eq(expected_value), message
      end

      def assert_not(expected_value, message = nil)
        expect(expected_value).to be_falsy, message
      end

      def assert_not_equal(expected_value, actual_value, message = nil)
        expect(actual_value).not_to eq(expected_value), message
      end

      def assert_raise(*expected_types, &)
        expect(&).to raise_error(*expected_types)
      end

      private

      def assert_difference_call(code)
        if code.is_a?(::Proc)
          code.call
        elsif code.is_a?(::String)
          eval(code) # rubocop:disable Security/Eval
        else
          raise "Unmapped type for \"#{code}\""
        end
      end
    end
  end
end
