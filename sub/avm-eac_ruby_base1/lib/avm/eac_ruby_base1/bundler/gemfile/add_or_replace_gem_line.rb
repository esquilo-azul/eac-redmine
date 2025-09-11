# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Bundler
      class Gemfile
        class AddOrReplaceGemLine
          enable_method_class
          common_constructor :sender, :gem_name, :gem_specs
          delegate :lines, to: :sender

          def existing_gem_line_index
            lines.index { |line| line.start_with?(gem_line_prefix) }
          end

          def result
            if existing_gem_line_index.present?
              replace_line
            else
              add_line
            end
          end

          def add_line
            lines.insert(add_line_index, new_gem_line)
          end

          def add_line_index
            (gems_lines_start_index..(lines.count - 1)).each do |e|
              return e if new_gem_line < lines[e]
            end
            lines.count
          end

          def gems_lines_start_index
            lines.index { |line| line.start_with?('gem ') } || lines.count
          end

          def new_gem_line
            ([gem_line_prefix] + gem_specs).join(', ')
          end

          def gem_line_prefix
            "gem '#{gem_name}'"
          end

          def replace_line
            lines[existing_gem_line_index] = new_gem_line
          end
        end
      end
    end
  end
end
