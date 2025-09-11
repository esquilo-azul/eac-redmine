# frozen_string_literal: true

module Avm
  module Sources
    module Tests
      class Builder
        NO_TEST_TEST_NAME = 'no_test'

        enable_immutable

        immutable_accessor :include_main, :include_subs, type: :boolean
        immutable_accessor :include_id, type: :array
        common_constructor :main_source

        def immutable_constructor_args
          [main_source]
        end

        # @return [Avm::Sources::Tests::Performer]
        def performer
          ::Avm::Sources::Tests::Performer.new(self)
        end

        def selected_units
          (select_units_from_subs + select_units_from_main + select_units_from_ids).sort.uniq
        end

        private

        # @return [Array<Avm::Sources::Tests::Single>]
        def available_units
          @available_units ||= ([main_source] + main_source.subs)
                                 .flat_map { |a_source| create_source_units(a_source) }
        end

        def available_units_from_main
          create_units([main_source])
        end

        def available_units_from_subs
          create_units(main_source.subs)
        end

        # @return [Avm::Sources::Tests::Single]
        def create_source_no_test_unit(source)
          ::Avm::Sources::Tests::Single.new(self, source, NO_TEST_TEST_NAME,
                                            source.env.command('true'))
        end

        # @return [Array<Avm::Sources::Tests::Single>]
        def create_source_units(source)
          tests = source.test_commands
          return create_source_no_test_unit(source) unless tests.any?

          tests.map do |test_name, test_command|
            ::Avm::Sources::Tests::Single.new(self, source, test_name, test_command)
          end
        end

        # @return [Array<Avm::Sources::Tests::Single>]
        def create_units(sources)
          sources.flat_map { |a_source| create_source_units(a_source) }
        end

        # @return [Avm::Sources::Tests::Single]
        def create_units_by_id(source_id)
          r = available_units.select { |unit| unit.source.relative_path.to_path == source_id.to_s }
          return r if r.any?

          raise ::ArgumentError, "Source not found with ID=#{source_id}" \
                                 "(Available: #{available_units.map(&:id).join(', ')})"
        end

        # @return [Array<Avm::Sources::Tests::Single>]
        def select_units_from_ids
          include_ids.flat_map { |source_id| create_units_by_id(source_id) }
        end

        # @return [Array<Avm::Sources::Tests::Single>]
        def select_units_from_main
          include_main? ? available_units_from_main : []
        end

        # @return [Array<Avm::Sources::Tests::Single>]
        def select_units_from_subs
          include_subs? ? available_units_from_subs : []
        end
      end
    end
  end
end
