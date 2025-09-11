# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Runners
      class Base
        class LibRename
          runner_with :help, :file_replacer do
            desc 'Rename Ruby modules classes Ruby.'
            arg_opt '-f', '--from', 'Rename "from".'
            arg_opt '-t', '--to', 'Rename "to".'
          end

          def run
            start_banner
            validate
            replacements_banner
            run_filesystem_traverser
            success 'Done!'
          end

          def validate
            %w[from to].each do |opt|
              fatal_error "No \"#{opt}\" option" if send(opt).blank?
            end
          end

          def start_banner
            infov 'From', from
            infov 'To', to
          end

          private

          def namespace_replacer_uncached
            ::Avm::EacRubyBase1::Sources::NamespaceReplacer.new(from, to)
          end

          def text_replacer
            @text_replacer ||= super.gsub(from, to).gsub(from_path, to_path)
                                 .gsub(namespace_replacer.from_result, namespace_replacer.to_result)
          end

          def replace_file?(file)
            file.extname == '.rb'
          end

          def replacements_banner
            infov 'Replacements', text_replacer.replacements.count
            text_replacer.replacements.each do |rep|
              infov '  * ', rep
            end
          end

          def from
            parsed.from.to_s
          end

          def to
            parsed.to.to_s
          end

          def from_path
            from.underscore
          end

          def to_path
            to.underscore
          end
        end
      end
    end
  end
end
