# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        class RubocopCommand
          acts_as_immutable
          immutable_accessor :ignore_parent_exclusion, :autocorrect, :autocorrect_all,
                             type: :boolean
          immutable_accessor :file, type: :array
          common_constructor :source
          delegate :execute, :execute!, :system, :system!, to: :bundle_command

          # @return [Enumerable]
          def immutable_constructor_args
            [source]
          end

          # @return [Gemspec::Version]
          def version
            @version ||= ::Gemspec::Version.new(
              source.bundle('exec', 'rubocop', '--version').execute!
            )
          end

          private

          # @return [String]
          def autocorrect_option
            '--auto-correct'
          end

          # @return [String]
          def autocorrect_all_option
            '--auto-correct-all'
          end

          # @return [String]
          def ignore_parent_exclusion_option
            '--ignore-parent-exclusion'
          end

          # @return [Avm::EacRubyBase1::Sources::Base::BundleCommand]
          def bundle_command
            source.bundle(*bundle_command_args)
          end

          # @return [Array<String>]
          def bundle_command_args
            %w[exec rubocop] + rubocop_command_args
          end

          # @return [Array<String>]
          def rubocop_command_args
            r = []
            r += ['--config', source.rubocop_config_path] if source.rubocop_config_path.file?
            r << ignore_parent_exclusion_option if ignore_parent_exclusion?
            if autocorrect_all?
              r << autocorrect_all_option
            elsif autocorrect?
              r << autocorrect_option
            end
            r + files
          end
        end
      end
    end
  end
end
