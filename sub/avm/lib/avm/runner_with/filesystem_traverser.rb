# frozen_string_literal: true

require 'eac_cli/runner'

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/settings_provider'

module Avm
  module RunnerWith
    module FilesystemTraverser
      DEFAULT_DEFAULT_TRAVERSER_RECURSIVE = false

      common_concern do
        include ::EacCli::Runner
        include ::EacFs::Traversable

        enable_settings_provider
        include TopMethods

        runner_definition do
          bool_opt '-R', '--recursive', 'Recursive.'
          bool_opt '--no-recursive', 'No recursive.'
          pos_arg :paths, optional: true, repeat: true
        end
      end

      module TopMethods
        def on_none_path_informed
          infom 'Warning: none path informed'
        end

        def paths
          parsed.paths.map(&:to_pathname)
        end

        def run_filesystem_traverser
          if paths.any?
            paths.each { |path| traverser_check_path(path) }
          else
            on_none_path_informed
          end
        end

        def traverser_recursive
          return false if parsed.no_recursive?
          return true if parsed.recursive?

          setting_value(:default_traverser_recursive, required: false)
            .if_not_nil(DEFAULT_DEFAULT_TRAVERSER_RECURSIVE)
        end
      end
    end
  end
end
