# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class IncompatibleParser
        class LineBuffer
          class << self
            def from_file(path)
              new(::File.read(path.to_s))
            end
          end

          attr_reader :gems_in_conflict

          def initialize(content)
            self.gems_in_conflict = []
            self.parsing_required = false
            content.each_line { |string_line| add_line(LineFactory.new(string_line)) }
          end

          private

          attr_accessor :parsing_required
          attr_writer :gems_in_conflict

          def add_line(line)
            return if line.blank?

            return if LineFactory::TYPES.any? do |type|
              next false unless line.result.is_a?(type)

              send("on_#{type.name.demodulize.underscore.variableize}_line", line.result)
              true
            end

            return unless parsing_required

            raise(::ArgumentError, "Unparsed line: \"#{line.content}\"")
          end

          def on_gem_conflict_line(result)
            self.parsing_required = true
            gems_in_conflict << result
          end

          def on_in_gemfile_line(result)
            # Do nothing
          end

          def on_depends_on_line(result)
            current_gem_conflict.add_depends_on(result)
          end

          def on_ruby_requirement_line(result)
            # Do nothing
          end

          def on_version_requirement_line(result)
            current_gem_conflict.add_version_requirement(result)
          end

          def current_gem_conflict
            raise 'No gems in conflict' if gems_in_conflict.none?
            raise 'Last gem is blank' if gems_in_conflict.last.blank?

            gems_in_conflict.last
          end
        end
      end
    end
  end
end
