# frozen_string_literal: true

require 'eac_config/yaml_file_node'

require 'shellwords'

module Avm
  module Sources
    class Base
      module Configuration
        PARENT_CONFIGURATION_SUFFIX = %w[subs at].freeze
        CONFIGURATION_FILENAMES = %w[.avm.yml .avm.yaml].freeze

        # @return [EacConfig::NodeEntry]
        def configuration_entry(*entry_args)
          parent_configuration.if_present do |v|
            parent_entry = v.entry(*entry_args)
            return parent_entry if parent_entry.found?
          end

          configuration.entry(*entry_args)
        end

        # The possible absolute paths for configuration files.
        #
        # @return [Array<Pathname>]
        def configuration_paths
          CONFIGURATION_FILENAMES.map { |filename| path.join(filename) }
        end

        # @return [EacRubyUtils::Envs::Command, nil]
        def configuration_value_to_env_command(value)
          return value if value.is_a?(::EacRubyUtils::Envs::Command)

          configuration_value_to_shell_words(value).if_present { |v| env.command(v).chdir(path) }
        end

        # @return [Array<String>, nil]
        def configuration_value_to_shell_words(value)
          return nil if value.blank?

          value.is_a?(::Enumerable) ? value.map(&:to_s) : ::Shellwords.split(value.to_s)
        end

        # @return [Array<String>, nil]
        def read_configuration_as_shell_words(key)
          configuration_value_to_shell_words(configuration_entry(key).value)
        end

        # Utility to read a configuration as a [EacRubyUtils::Envs::Command].
        # @return [EacRubyUtils::Envs::Command]
        def read_configuration_as_env_command(key)
          configuration_value_to_env_command(configuration_entry(key).value)
        end

        private

        # @return [EacConfig::YamlFileNode]
        def configuration_uncached
          configuration_paths.each do |config_path|
            configuration_with_filename(config_path, true)
          end
          configuration_with_filename(configuration_paths.first, false)
        end

        # @return [Enumerable<String>]
        def parent_configuration_prefix
          PARENT_CONFIGURATION_SUFFIX + [relative_path.to_path.gsub(/\A\.+|\.+\z/, '')]
        end

        # @return [EacConfig::PrefixedPathNode]
        def parent_configuration_uncached
          parent.if_present { |v| v.configuration.with_prefix(parent_configuration_prefix) }
        end

        # @return [EacConfig::YamlFileNode, nil]
        def configuration_with_filename(config_path, needs_exist)
          return ::EacConfig::YamlFileNode.new(config_path) if !needs_exist || config_path.exist?

          nil
        end

        # @return [Avm::Sources::Configuration]
        def old_configuration_uncached
          ::Avm::Sources::Configuration.find_in_path(path) ||
            ::Avm::Sources::Configuration.temp_instance
        end
      end
    end
  end
end
