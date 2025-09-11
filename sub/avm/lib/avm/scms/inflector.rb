# frozen_string_literal: true

module Avm
  module Scms
    class Inflector
      class << self
        def default_instance
          @default_instance ||= new
        end
      end

      ISSUE_POINTER_NAME_PREFIX = 'issue_'
      POINTER_NAME_TO_ISSUE_PATTERN = /\A#{Regexp.quote(ISSUE_POINTER_NAME_PREFIX)}(\d+)\z/.freeze
      POINTER_NAME_TO_ISSUE_PARSER = POINTER_NAME_TO_ISSUE_PATTERN.to_parser { |m| m[1] }

      # @return [String, nil]
      def pointer_name_to_issue_id(pointer_name)
        POINTER_NAME_TO_ISSUE_PARSER.parse(pointer_name)
      end
    end
  end
end
