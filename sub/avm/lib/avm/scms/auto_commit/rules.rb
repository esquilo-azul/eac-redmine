# frozen_string_literal: true

module Avm
  module Scms
    module AutoCommit
      module Rules
        require_sub __FILE__

        RULES_CLASSES = %w[last manual new nth unique]
                          .map { |key| ::Avm::Scms::AutoCommit::Rules.const_get(key.camelcase) }

        class << self
          # @return [Array<Avm::Scms::AutoCommit::Rules>]
          def all
            RULES_CLASSES
          end

          def parse(string)
            parts = string.split(':')

            klass = rule_class_by_key(parts.shift)
            klass.new(*parts)
          end

          def rule_class_by_key(key)
            RULES_CLASSES.find { |klass| klass.keys.include?(key) } ||
              raise("Rule not find with key \"#{key}\" (Available: " \
                    "#{RULES_CLASSES.flat_map(&:keys).join(', ')})")
          end
        end
      end
    end
  end
end
