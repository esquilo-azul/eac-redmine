# frozen_string_literal: true

require 'eac_config/old_configs'

require 'yaml'

module Avm
  module Sources
    class Configuration < ::EacConfig::OldConfigs
      require_sub __FILE__, include_modules: true

      FILENAMES = %w[.avm.yml .avm.yaml].freeze

      class << self
        def find_by_path(path)
          path = ::Pathname.new(path.to_s) unless path.is_a?(::Pathname)
          internal_find_path(path.expand_path)
        end

        def find_in_path(path)
          absolute_pathname = path.to_pathname.expand_path
          if absolute_pathname.directory?
            FILENAMES.each do |filename|
              file = absolute_pathname.join(filename)
              return new(file) if file.exist?
            end
          end
          nil
        end

        def temp_instance
          new(::Tempfile.new(['.avm', '.yaml']))
        end

        private

        def internal_find_path(absolute_pathname)
          r = find_in_path(absolute_pathname)
          return r if r.present?

          internal_find_path(absolute_pathname.dirname) unless absolute_pathname.root?
        end
      end

      def initialize(path)
        super(nil, storage_path: path)
      end

      # Utility to read a configuration as a [EacRubyUtils::Envs::Command].
      # @return [EacRubyUtils::Envs::Command]
      def read_command(key)
        read_entry(key).if_present do |v|
          args = v.is_a?(::Enumerable) ? v.map(&:to_s) : ::Shellwords.split(v)
          ::EacRubyUtils::Envs.local.command(args).chdir(::File.dirname(storage_path))
        end
      end
    end
  end
end
