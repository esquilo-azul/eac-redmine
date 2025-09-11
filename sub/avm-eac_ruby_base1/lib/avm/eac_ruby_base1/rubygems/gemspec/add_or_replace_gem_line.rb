# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class Gemspec
        class AddOrReplaceGemLine
          enable_method_class
          common_constructor :sender, :gem_name, :gem_specs, :dependency_type do
            self.dependency_type = ::Avm::EacRubyBase1::Rubygems::Gemspec::Dependency.lists.type
                                     .value_validate!(dependency_type)
          end
          delegate :lines, to: :sender

          DEPENDENCY_PREFIX = '  s.add%<dependency_type>s_dependency \'%<gem_name>s\''

          # @return [Integer]
          def existing_gem_line_index
            lines.index do |line|
              ::Avm::EacRubyBase1::Rubygems::Gemspec::DEPENDENCY_LINE_PARSER.parse(line)
                .if_present(&:first) == gem_name
            end
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

          # @return [Integer]
          def gems_lines_start_index
            existing_gem_line_index || (lines.count - 1)
          end

          def new_gem_line
            ([gem_line_prefix] + quoted_gem_specs).join(', ')
          end

          # @return [String]
          def gem_line_prefix
            format(DEPENDENCY_PREFIX, { dependency_type: dependency_type, gem_name: gem_name })
          end

          def replace_line
            lines[existing_gem_line_index] = new_gem_line
          end

          def quoted_gem_specs
            gem_specs.map { |gem_spec| "'#{gem_spec}'" }
          end
        end
      end
    end
  end
end
